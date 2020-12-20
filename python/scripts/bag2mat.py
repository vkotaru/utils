#!/usr/bin/python2
"""@package bag2mat
script to convert a list of bag files to mat files
"""
import utils
import argparse
import  os

def convert_bag2mat(_file, ignore_msgs_=None):
    """
    function to read a bag file and save the data to a mat file
    for instance, 
    /path/to/file.bag is converted to /path/to/file.mat
    @param [in] _file file name as a string
    @param [in] ignore_msgs_ list of message types to be ignored during the conversion
    """
    # read ros-bag file
    ros_bag_ = utils.ros.BagReader(_file.name)
    if ignore_msgs_ is not None:
        ros_bag_.ignore_msg_type(ignore_msgs_)

    # read rosbag
    ros_bag_.read()

    # saving the data to *.mat file
    ros_bag_.save_to(os.path.splitext(_file.name)[0]+'.mat')

def main():
    """
    bag2mat main function
    """
    parser = argparse.ArgumentParser(description='Process ros-bag to mat.')
    parser.add_argument('-f', '--file', type=file, nargs='+', help='rosbag filename', required=True)
    parser.add_argument('-i', '--ignore', type=str, nargs='+', help='ros message types to be ignored')

    args = parser.parse_args()
    for i in range(len(args.file)):
        # processing rosbag
        print('processing \033[0;32m'+args.file[i].name+'\033[0m')
        convert_bag2mat(args.file[i], args.ignore)

if __name__ == "__main__":
    main()