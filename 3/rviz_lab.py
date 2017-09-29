#!/usr/bin/env python

import rospy, time, random
from geometry_msgs.msg import Point
from visualization_msgs.msg import Marker



def prepare_answer(message):
    correct_fout = open('/root/answer_file.txt','a')
    correct_fout.write(str(message.x) + str(message.y) + str(message.z) + '\n')
    correct_fout.close()

def test_answer(message):
    global set_type
    received_fout = open('/root/received_file.txt','a')
    
    received_fout.write(str(message.pose.position.x) + str(message.pose.position.y) + str(message.pose.position.z) + '\n')
    if set_type != -1:
        if set_type != message.type:
            received_fout.write('error: unexpected type changing of several markers\n')
    else:
        set_type = message.type
    
    if len(id_arr) == 0:
        id_arr.append(message.id)
        return
    if not message.id in id_arr:
        id_arr.append(message.id)
    else:
        received_fout.write('error: received the marker(s) with the same id\n')
    received_fout.close()

if __name__ == '__main__':
    set_type = -1
    id_arr = []
    fout = open('/root/answer_file.txt','w')
    fout.close()
    ffout = open('/root/received_file.txt','w')
    ffout.close()

    rospy.init_node('pub_and_check', anonymous=True, log_level=rospy.INFO)
    rospy.Subscriber("/input", Point, prepare_answer)
    rospy.Subscriber("/output", Marker, test_answer)
    pub_test = rospy.Publisher("/input", Point, queue_size=10)
    time.sleep(1)
    msg = Point()
    random.seed(time.time())
    for i in range (0,5):
        msg.x = round(random.uniform(0, 8))
        msg.y = round(random.uniform(0, 9))
        msg.z = round(random.uniform(0, 8))
        pub_test.publish(msg)
        time.sleep(0.2)

    time.sleep(10)
