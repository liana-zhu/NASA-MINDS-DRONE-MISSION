from djitellopy import Tello
import cv2

width = 320
height = 240
startCounter = 0

drone = tello.Tello()
drone.connect()
print(drone.get_battery())

drone.streamon()

# 0: forward camera
# 1: bottom camera
drone.set_video_direction(1)
while True:
    img = drone.get_frame_read().frame
    #img = cv2.resize(img, (360,240))
    cv2.imshow("Image", img)
    cv2.waitKey(1)