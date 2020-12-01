
from utils import test_module as ut
from utils import bag_reader

# main section of the code

if __name__ == '__main__':

    print('Hello World!')
    ut.test_module_func()

    # bag_filename = '/home/kotaru/workspace/research/geometric_estimation/experiments/2018-10-23-17-06-03.bag'
    bag_filename = '/home/kotaru/workspace/catkin_ws/qrotor_firmware_ws/bags/test2_raw_load_pose/2020-11-30-15-59-49.bag'
    br = bag_reader.BagReader(bag_filename)
    br.read()

    print('Good Day!')

