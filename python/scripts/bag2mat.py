#!/usr/bin/python2
"""@package bag2mat
script to convert a list of bag files to mat files
"""
import utils
import argparse
import  os

def main():
    """
    bag2mat main function
    """
    parser = argparse.ArgumentParser(description='Process ros-bag to mat.')
    parser.add_argument('-f', '--file', type=file, nargs='+', help='rosbag filename', required=True)
    parser.add_argument('-i', '--ignore', type=str, nargs='+', help='ros message types to be ignored')
    parser.add_argument('-p', '--save_pickle', default=False, action='store_true')

    args = parser.parse_args()
    
    params = {}
    params['ignore_msgs'] = args.ignore
    params['save_pickle'] = args.save_pickle
    
    for i in range(len(args.file)):
        # processing rosbag
        print('processing \033[0;32m'+args.file[i].name+'\033[0m')
        utils.ros.bag_reader.convert_bag(args.file[i], params)

if __name__ == "__main__":
    main()