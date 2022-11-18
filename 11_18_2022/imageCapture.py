from djitellopy import Tello
import keyboard as key
import cv2
import time

width = 320
height = 240
startCounter = 0

drone = Tello()
drone.connect()
print(drone.get_battery())

key.init()
drone.streamon()

# 0: forward camera
# 1: bottom camera
drone.set_video_direction(1)

drone.takeoff()

while True:
    image = drone.get_frame_read().frame
    #img = cv2.resize(img, (360,240))
    cv2.imshow("Image", image)
    cv2.imwrite(f'11_18_2022/image-capture/{time,time()}.jpg', image)
    drone.rotate_clockwise(90)
    time.sleep(3)
    drone.move_left(35)
    time.sleep(3)
    # if cv2.waitKey(32) == ord('Space'):
    #     drone.land()
    #     break
    
    if key.read_key() == 'space':
        drone.land()
        break