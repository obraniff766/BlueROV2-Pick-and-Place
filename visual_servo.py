import time
import cv2
import matplotlib.pyplot as plt
from ultralytics import YOLO
from pymavlink import mavutil
from stream import Video 

# getting YOLO model
YOLO_model = 'C:/yolo_project/drinkcandetect/yolomodel/runs/obb/BlueROV2_detect/drink_can_obb_detection/weights/best.pt'
classes = [0, 1]

# gripper control setup
Servo = 9
Gripper_Open = 1900
Gripper_Close = 1100
Gripper_Stop = 1500

# gripping area pixel coordinates
x_min, x_max = 616, 850
y_min, y_max = 347, 750

# can pixel dimensions
can_width = x_max - x_min  
can_length = y_max - y_min 

# servoing gains
sway_gain = 0.1
heave_gain = 0.1
yaw_gain = 0.1

# forward speed
surge_speed = 1580

# error tolerance
control_tolerance = 20 #pixels

# time the can needs to remain stable in target box
time_stable = 0.5

# connect to mavlink
bluerov2 = mavutil.mavlink_connection('udpin:0.0.0.0:14550')
bluerov2.wait_heartbeat()
print("Connected to BlueROV2 Heavy - Heartbeat ok")

def stop_bluerov2():
    # reset thrusters to neutral (1500 pmw)
    rc_values = [1500] * 8 #6?
    # send mavlink command
    bluerov2.mav.rc_channels_override_send(
        bluerov2.target_system, bluerov2.target_component, *rc_values)

def move_bluerov2(surge=1500, sway=1500, heave=1500, yaw=1500):
    # send RC override command
    rc_values = [65535] * 8 #6?
    # map control to rc values channels 0-5
    rc_values[0] = 1500
    rc_values[1] = 1500
    rc_values[2] = heave
    rc_values[3] = yaw
    rc_values[4] = surge
    rc_values[5] = sway
    bluerov2.mav.rc_channels_override_send(
        bluerov2.target_system, bluerov2.target_component, *rc_values)

def control_gripper(pwm):
    # command to control gripper
    bluerov2.mav.command_long_send(
        bluerov2.target_system, bluerov2.target_component,
        mavutil.mavlink.MAV_CMD_DO_SET_SERVO,
        0, Servo, pwm, 0, 0, 0, 0, 0
    )

model = YOLO(YOLO_model)

def visual_control():
    video = Video(port=5601) 
    servoing_active = False 
    start_time = None

    # inti data for plots
    times, err_x, err_y = [], [], []
    pwms_surge, pwms_sway, pwms_heave, pwms_yaw = [], [], [], []
    traj_x, traj_y = [], []
    mission_start = time.time()

    # define centre of cans
    target_x_center = (x_min + x_max) / 2
    target_y_center = (y_min + y_max) / 2

    print("\nReady to start algorithm.")
    print("Press: 'G' Start / 'S' Stop / 'Q' Quit")

    while True:
        test_frame = video.frame()
        # stops script from detecting when stream frames lag
        if test_frame is None:
            time.sleep(0.01)
            continue

        frame = test_frame.copy()
        
        # detection model + stop yolo spamming the terminal
        detection = model.predict(frame, conf=0.7, verbose=False)
        # draw object bounding boxes
        desired_position_box = detection[0].plot()
        # drawing green target box
        cv2.rectangle(desired_position_box, (x_min, y_min), (x_max, y_max), (0, 255, 0), 2)
        cv2.imshow("BlueROV YOLO Visual Servoing Control", desired_position_box)
        # command keys
        key = cv2.waitKey(1) & 0xFF
        if key == ord('g'):
            servoing_active = True
            print("STARTED")
        elif key == ord('s'):
            servoing_active = False
            stop_bluerov2()
            control_gripper(Gripper_Stop)
            print("STOPPED")
        elif key == ord('q'):
            stop_bluerov2()
            print("SYSTEM SHUTDOWN")
            break

        can_found = False

        if detection[0].obb is not None:
            # check that there is a can in water
            for object in detection[0].obb:
                can_found = True
                # find pixel coordinates of object
                coords = object.xywhr[0].tolist()
                x_coord, y_coord, w_object, l_object = coords[0], coords[1], coords[2], coords[3]
                # check position of object is in gripper area
                in_box = (x_min < x_coord < x_max) and (y_min < y_coord < y_max)
                in_position = (w_object > (can_width * 0.55)) and (l_object > (can_length * 0.5))

                # check if visual servoing engaged
                if servoing_active:
                    # define errors as
                    error_x = x_coord - target_x_center
                    error_y = y_coord - target_y_center

                    # logic for movement
                    sway_pwm  = 1500 + int(error_x * sway_gain)
                    yaw_pwm  = 1500 + int(error_x * yaw_gain)
                    heave_pwm = 1500 - int(error_y * heave_gain)
                    fwd_pwm  = surge_speed if not in_position else 1500

                    # tolerance checks - stops jitter
                    actual_sway  = sway_pwm  if abs(error_x) > control_tolerance else 1500
                    actual_yaw  = yaw_pwm  if abs(error_x) > control_tolerance else 1500
                    actual_heave = heave_pwm if abs(error_y) > control_tolerance else 1500
                    # call function to send rc thruster commands
                    move_bluerov2(surge=fwd_pwm, sway=actual_sway, heave=actual_heave, yaw=actual_yaw)

                    # log the data for plots
                    times.append(time.time() - mission_start)
                    err_x.append(error_x)
                    err_y.append(error_y)
                    pwms_surge.append(fwd_pwm)
                    pwms_sway.append(actual_sway)
                    pwms_heave.append(actual_heave)
                    pwms_yaw.append(actual_yaw)
                    traj_x.append(x_coord)
                    traj_y.append(y_coord)

                    # gripper trigger logic
                    if in_box and in_position:
                        if start_time is None: start_time = time.time()
                        time_elapsed = time.time() - start_time
                        cv2.putText(desired_position_box, f" Gripping Can! ", (int(x_coord), int(y_coord) - 40), 
                                    cv2.FONT_HERSHEY_SIMPLEX, 0.8, (0, 255, 255), 2)
                        # grab can if in position and stable
                        if time_elapsed >= time_stable:
                            stop_bluerov2()
                            print("GRABBING CAN!!!")
                            control_gripper(Gripper_Close); time.sleep(1.5); control_gripper(Gripper_Stop)
                            time.sleep(20.0)
                            control_gripper(Gripper_Open); time.sleep(1.5); control_gripper(Gripper_Stop)
                            servoing_active = False
                            start_time = None
                    break 
        # stop if no can in water
        if servoing_active and not can_found:
            stop_bluerov2()
            start_time = None

        

    cv2.destroyAllWindows()

    # plots
    if times:
        fig, (ax1, ax2, ax3) = plt.subplots(1, 3, figsize=(18, 5))
        fig.suptitle('BlueROV2 Autonomous Marine Debris Recovery Results', fontsize=16)
        # convergence
        ax1.plot(times, err_x, label='Error X', color='blue')
        ax1.plot(times, err_y, label='Error Y', color='red')
        ax1.axhline(y=control_tolerance, color='green', linestyle='--', label='Tolerance')
        ax1.axhline(y=-control_tolerance, color='green', linestyle='--')
        ax1.set_title("UUV's Convergence On Drink Can")
        ax1.set_xlabel("Time (s)"); ax1.set_ylabel("Visual servoing error (in pixels)"); ax1.legend()

        # control effort
        ax2.plot(times, pwms_surge, label='Surge PWM', color='green')
        ax2.plot(times, pwms_sway, label='Sway PWM', color='red')
        ax2.plot(times, pwms_heave, label='Heave PWM', color='blue')
        ax2.plot(times, pwms_yaw, label='Yaw PWM', color='orange') 
        ax2.axhline(y=1500, color='black', linestyle='-', alpha=0.3)
        ax2.set_title("Control Effort (PWM Command Values)")
        ax2.set_xlabel("Time (s)"); ax2.set_ylabel("PWM (us)"); ax2.legend()

        # Drink can trajectory
        ax3.scatter(traj_x, traj_y, c=times, cmap='viridis', s=10) #coloured scatter graph
        ax3.invert_yaxis() # matches camera vision
        ax3.set_title("Visual Trajectory of The Drink Can's Center")
        ax3.set_xlabel("X (pixels)"); ax3.set_ylabel("Y (pixels)")
        plt.colorbar(ax3.collections[0], ax=ax3, label='Time (s)')

        plt.tight_layout()
        plt.show()
    
# only runs if executed properly
if __name__ == "__main__":
    visual_control()