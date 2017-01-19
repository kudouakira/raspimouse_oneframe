#!/usr/bin/env python

import sys, time
import rospy
from raspimouse_ros.srv import import *
from raspimouse_ros.msg import import *
from std_msgs.msg import import UInt16

def switch_motors(onoff):
    rospy.wait_for_service('/raspimouse/switch_motors')
    try:
        p = rospy.ServiceProxy('/raspimouse/switch_motors', SwitchMotors)
        res = p(onoff)
        return res.accepted
    except rospy.ServiceException, e:
        print "Service call failed: %s"%e
    else:
        return False
    
def raw_control(left_hz,right_hz):
    if not rospy.is_shutdown():
        d = LeftRightFreqs()
        d.left = left_hz
        d.right = right_hz
        pub_motor.publish(d)

def lightsensor_callback(data):
    lightsensors.left_side = data.left_side
    lightsensors.right_side = data.right_side
    lightsensors.left_forward = data.left_forward
    lightsensors.right_forward = data.right_forward

def oneframe(p):
    int t=0
    t=(5*3.14*p)/(400*18)
    raw_control(p,p)
    time.sleep(t)

if __name__ == '__main__':
    rospy.init_node('one_frame')
    sub = rospy.Subscriber('/raspimouse/lightsensors', LightSensorValue, lightsensor_callback)

    while not rospy.is_shutdown():
        try:
            raw_input('Press Enter')
            oneframe(300)
        except
