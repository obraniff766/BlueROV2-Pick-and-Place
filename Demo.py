import time
import cv2
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

# time the can needs to remain stable in target box
time_stable = 0.5 

# connect to mavlink
bluerov2 = mavutil.mavlink_connection('udpin:0.0.0.0:14550')
bluerov2.wait_heartbeat()
print("Connected to BlueROV2 - Heartbeat ok")

# gripper mavlink command
def control_gripper(pwm):
    bluerov2.mav.command_long_send(
        bluerov2.target_system, bluerov2.target_component,
        mavutil.mavlink.MAV_CMD_DO_SET_SERVO,
        0, Servo, pwm, 0, 0, 0, 0, 0
    )

model = YOLO(YOLO_model)

# function for visual control detecting cans
def visual_control():

    video = Video(port=5600) 
    
    last_grab_time = 0
    # 5 second reset
    reset_time = 5
    start_time = None

    print("Press q to stop")

    while True:
        
        test_frame = video.frame()
        # stops script from detecting when stream frames lag 
        if test_frame is None:
            time.sleep(0.01)
            continue

        frame = test_frame.copy() 
        current_time = time.time()
        in_reset = (current_time - last_grab_time) < reset_time

        # drawing green target box
        cv2.rectangle(frame, (x_min, y_min), (x_max, y_max), (0, 255, 0), 2)
        
        # detection model + stop yolo spamming the terminal
        detection = model.predict(frame, conf=0.7, verbose=False)
        # draw object bounding boxes
        desired_position_box = detection[0].plot() 

        can_found = False
        # check that not in reset mode
        if not in_reset:
            for r in detection:
                # check that there is a can in water
                if r.obb is not None:
                    for object in r.obb:
                        # classify object (0=boost, 1=coke)
                        class_id = int(object.cls[0])
                        # find pixel coordinates of object
                        coords = object.xywhr[0].tolist()
                        x_coord, y_coord, w_object, l_object = coords[0], coords[1], coords[2], coords[3]

                        # check position of object is in gripper area
                        in_box = (x_min < x_coord < x_max) and (y_min < y_coord < y_max)
                        # check its in desired position (close enough in pixel width) ~55% in desired position was accurate
                        in_position = (w_object > (can_width * 0.55)) and (l_object > (can_length * 0.5))

                        # display if object is in right position (green) or not (red)
                        hud_colour = (0, 255, 0) if (in_box and in_position) else (0, 0, 255)
                        class_name = " Boost " if class_id == 0 else " Coke "
                        position = " In position: Grabbing can " if (in_box and in_position) else " Object not in position!"
                        status = f"Class detected:{class_name} | {position} "
                        cv2.putText(desired_position_box, status, (20, 50), 
                                        cv2.FONT_HERSHEY_SIMPLEX, 0.7, hud_colour, 2)
                        
                        # if can in right position
                        if in_box and in_position:
                            can_found = True
                                
                            if start_time is None:
                                start_time = time.time()

                            # Show Gripping label on can
                            cv2.putText(desired_position_box, f" Gripping Can! ", (int(x_coord), int(y_coord) - 40), 
                                        cv2.FONT_HERSHEY_SIMPLEX, 0.8, (0, 255, 255), 2)
                            
                            # check that can is stable to grab and grip it for 3 seconds and let go
                            elapsed = time.time() - start_time
                            if elapsed >= time_stable:
                                control_gripper(Gripper_Close)
                                time.sleep(1.5)
                                control_gripper(Gripper_Stop)
                                time.sleep(3.0)
                    
                                control_gripper(Gripper_Open)
                                time.sleep(1.5)
                                control_gripper(Gripper_Stop)
                                    
                                last_grab_time = time.time()
                                start_time = None
                                break 

        if not can_found:
            start_time = None

        cv2.imshow("BlueROV YOLO Visual Servoing Control", desired_position_box)
        # press q to stop
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cv2.destroyAllWindows()
# only run if play is hit
if __name__ == "__main__":
    visual_control()