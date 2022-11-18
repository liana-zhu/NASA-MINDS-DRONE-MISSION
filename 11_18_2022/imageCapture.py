from djitellopy import Tello
import KeyPressModule as key
import cv2
import time

width = 320
height = 240
startCounter = 0

drone = tello.Tello()
drone.connect()
print(drone.get_battery())

key.init()
drone.streamon()

# 0: forward camera
# 1: bottom camera
drone.set_video_direction(1)
while True:
    image = drone.get_frame_read().frame
    #img = cv2.resize(img, (360,240))
    cv2.imshow("Image", image)
    cv2.imwrite(f'11_18_2022/image-capture/{time,time()}.jpg', image)
    cv2.waitKey(1)