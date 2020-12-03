import utils
import argparse
import  os

def convert_bag2mat(_file):
    # read ros-bag file
    ros_bag_ = utils.ros.BagReader(_file.name)

    # read rosbag
    ros_bag_.read()

    # saving the data to *.mat file
    ros_bag_.save_to(os.path.splitext(_file.name)[0]+'.mat')

def main():
    parser = argparse.ArgumentParser(description='Process ros-bag to mat.')
    parser.add_argument('-f', '--file', type=file, help='rosbag filename', required=True)

    args = parser.parse_args()
    convert_bag2mat(args.file)

if __name__ == "__main__":
    main()