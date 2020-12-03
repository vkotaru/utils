from utils.ros.bag_reader import BagReader
import utils

# filename = '/home/kotaru/workspace/catkin_ws/qrotor_firmware_ws/bags/test2_raw_load_pose/2020-11-30-15-59-49.bag'
filename = '/home/kotaru/catkin_ws/bags/oct25/rs-room-test1.bag'
rb = utils.ros.BagReader(filename)

print(rb)

i = 0
for topic, msg, _ in rb.bag.read_messages(topics=[rb.topics[0],'numbers']):
    """ Recursively list the fields in each message """
    if i==0:
        BagReader.print_topic_fields(topic, msg, 0)
        _dict = rb.identify_topic_fields(topic, msg, 0)
    _dict = rb.append_msg(_dict, msg)
    if i > 10:
        break
    i+=1

BagReader.save_to(_dict)
print('done!')