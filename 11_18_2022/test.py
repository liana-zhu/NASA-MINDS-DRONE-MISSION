from djitellopy import tello
from time import sleep

drone = tello.Tello()
drone.connect()
print(drone.get_battery())

tello.enable_mission_pads()
tello.set_mission_pad_detection_direction(1)

drone.takeoff()

pad = tello.get_mission_pad_id()

while pad != 1:
    if pad == 3:
        tello.move_back(30)
        tello.rotate_clockwise(90)

    if pad == 4:
        tello.move_up(30)
        tello.flip_forward()

    pad = tello.get_mission_pad_id()
    
tello.disable_mission_pads()

drone.land()
tello.end()