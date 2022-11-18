from djitellopy import Tello
import cv2
import time
 
######################################################################
width = 1024  # WIDTH OF THE IMAGE
height = 768  # HEIGHT OF THE IMAGE
startCounter =0   #  0 FOR FIGHT 1 FOR TESTING
######################################################################
 
# CONNECT TO TELLO
drone = Tello()
drone.connect()
drone.for_back_velocity = 0
drone.left_right_velocity = 0
drone.up_down_velocity = 0
drone.yaw_velocity = 0
drone.speed = 0
 
print(drone.get_battery())
 
drone.streamon()

# 0: forward camera
# 1: bottom camera
drone.set_video_direction(1)
 
while True:
 
    # Get the image from the drone
    frame_read = drone.get_frame_read()
    myFrame = frame_read.frame
    image = cv2.resize(myFrame, (width, height))
 
    # You guys can custom the flight path here
    if startCounter == 0:
        drone.takeoff()
        time.sleep(8)
        drone.rotate_clockwise(90)
        time.sleep(3)
        drone.move_left(35)
        time.sleep(3)
        drone.land()
        startCounter = 1

 
    # Display image
    cv2.imshow("Result", image)
 
    # Press Space to land the drone
    if cv2.waitKey(32) == ord('Space'):
        drone.land()
        break