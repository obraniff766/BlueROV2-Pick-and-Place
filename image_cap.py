import cv2
import time
import os
from stream import Video 

# start stream
video = Video(port=5600)
# output images
output_folder = "C:/yolo_project/test/images_training_data3"

if not os.path.exists(output_folder):
    os.makedirs(output_folder)

last_capture_time = time.time()
count = 0

print("Press 'q' in the video window to stop.")

try:
    while True:
        frame = video.frame()
        
        if frame is not None:
            # show video feed
            cv2.imshow("Stream Feed", frame)
            
            # capture every second
            current_time = time.time()
            if current_time - last_capture_time >= 1:
                # timestamp to avoid overwriting files
                timestamp = time.strftime("%H%M%S")
                filename = f"{output_folder}/img_{timestamp}_{count}.jpg"
                cv2.imwrite(filename, frame)
                print(f"Captured: {filename}")
                
                count += 1
                last_capture_time = current_time

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

finally:
    video.stop()
    cv2.destroyAllWindows()
    print("Stopped")