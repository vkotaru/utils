from utils.ros.bag_reader import BagReader
import utils

filename = '/home/kotaru/workspace/catkin_ws/qrotor_firmware_ws/bags/test2_raw_load_pose/2020-11-30-15-59-49.bag'
rb = utils.ros.BagReader(filename)

print(rb)


for topic, msg, _ in rb.bag.read_messages(topics=[rb.topics[0],'numbers']):
    """ Recursively list the fields in each message """
    BagReader.print_topic_fields(topic, msg, 0)
    output = rb.identify_topic_fields(topic, msg, 0)
    break


print('done!')