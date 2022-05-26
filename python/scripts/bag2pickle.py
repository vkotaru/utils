#!/usr/bin/env python3
"""
bag_reader to read and parse a rosbag
TODO: (find and cite the original source to the print_topic_fields function)
"""
import numpy as np
import argparse
import os
import pathlib
import glob


import rosbag
import sys
import time
import math
import warnings
from rosbag.bag import Bag
import scipy as sp
import scipy.io as sio
# import IPython as ip
import pickle
import multiprocessing


# TODO: move them to utils.common package
def tic():
    """
    source: https://stackoverflow.com/questions/5849800/what-is-the-python-equivalent-of-matlabs-tic-and-toc-functions
    Homemade version of matlab tic and toc functions
    """
    import time
    global startTime_for_tictoc
    startTime_for_tictoc = time.time()


def toc():
    import time
    if 'startTime_for_tictoc' in globals():
        print("Elapsed time is " + str(time.time() -
              startTime_for_tictoc) + " seconds.")
    else:
        print("Toc: start time not set")


def header_to_time(header):
    return np.array(header['stamp']['secs'], float) + np.array(header['stamp']['nsecs'], float) * 1e-9


class BagReader(object):
    def __init__(self, _file=None, _args=None):
        # super(BagReader, self).__init__()

        self.file = None
        self.bag = None
        self.topics = None
        self.data = {}
        self.ignore_msg_type_ = ['sensor_msgs/CameraInfo',
                                 'sensor_msgs/Image',
                                 'rosgraph_msgs/Log',
                                 'tf2_msgs/TFMessage',
                                 'dynamic_reconfigure/ConfigDescription',
                                 'dynamic_reconfigure/Config']
        self.ignore_msg_topics_ = []

        if _file == None:
            warnings.warn("bag filename is missing", UserWarning)
        else:
            self.update(_file)

    def update(self, _file):
        self.file = _file
        self.bag = self.get_bag(self.file)
        self.topics = list(self.get_topics(self.bag))

    def ignore_msg_type(self, msg_type_):
        if isinstance(msg_type_, list):
            for i in range(len(msg_type_)):
                self.ignore_msg_type_.append(msg_type_[i])
        else:
            self.ignore_msg_type_.append(msg_type_)

    def ignore_msg_topic(self, msg_topic_):
        if isinstance(msg_topic_, list):
            for i in range(len(msg_topic_)):
                self.ignore_msg_topics_.append(msg_topic_[i])
        else:
            self.ignore_msg_topics_.append(msg_topic_)

    def approve_msg_type(self, msg_type_):
        # TODO: find if msg_type_ is in ignore_msg_type_ and remove it if yes
        pass

    @staticmethod
    def get_topics(bag):
        return bag.get_type_and_topic_info()[1].keys()

    @staticmethod
    def get_bag(filename):
        return rosbag.Bag(filename)

    def clear(self):
        self.name = None
        self.bag.close()
        self.bag = None
        self.topics = None
        self.data = {}

    def __str__(self):
        str = 'List of Topics in the bag:\n'
        for i in range(len(self.topics)):
            str = str + '\t' + self.topics[i] + '\n'
        return str

    def __repr__(self):
        return self.__str__()

    @staticmethod
    def identify_topic_fields(field_name, msg, depth):
        if hasattr(msg, '__slots__'):
            d = {}
            for slot in msg.__slots__:
                d[slot] = BagReader.identify_topic_fields(
                    slot, getattr(msg, slot), depth + 1)
            return d
        elif isinstance(msg, list):
            if (len(msg) > 0) and hasattr(msg[0], '__slots__'):
                l = []
                for slot in msg[0].__slots__:
                    l.append(BagReader.identify_topic_fields(
                        slot, getattr(msg[0], slot), depth + 1))
                return {field_name: l}
        else:
            return []

    @staticmethod
    def append_msg(_dict, _msg):
        if isinstance(_dict, dict):
            for k in _dict.keys():
                _dict[k] = BagReader.append_msg(_dict[k], getattr(_msg, k))
        else:
            if isinstance(_msg, list):
                if (len(_msg) > 0) and hasattr(_msg[0], '__slots__'):
                    warnings.warn('new use case found!')
            else:
                _dict.append(_msg)
        return _dict

    @staticmethod
    def print_topic_fields(field_name, msg, depth):
        """ Recursive helper function for displaying information about a topic in a bag. This descends
            through the nested fields in a message, an displays the name of each level. The indentation
            increases depending on the depth of the nesting. As we recursively descend, we propagate the
            field name.
                There are three cases for processing each field in the bag.
                1.  The field could have other things in it, for example a pose's translation may have
                    x, y, z components. Check for this by seeing if the message has slots.
                2.  The field could be a vector of other things. For instance, in the message file we
                    could have an array of vectors, like geometry_msgs/Vector[] name. In this case,
                    everything in the vector has the same format, so just look at the first message to
                    extract the fields within the list.
                3.  The field could be a terminal leaf in the message, for instance the nsecs field in a
                    header message. Just display the name.
        """
        if hasattr(msg, '__slots__'):
            """ This level of the message has more fields within it. Display the current
                    level, and continue descending through the structure.
            """
            print(' ' * (depth * 2) + field_name)
            for slot in msg.__slots__:
                BagReader.print_topic_fields(
                    slot, getattr(msg, slot), depth + 1)
        elif isinstance(msg, list):
            """ We found a vector of field names. Display the information on the current
                    level, and use the first element of the vector to display information
                    about its content
            """
            if (len(msg) > 0) and hasattr(msg[0], '__slots__'):
                print(' ' * (depth * 2) + field_name + '[]')
                for slot in msg[0].__slots__:
                    BagReader.print_topic_fields(
                        slot, getattr(msg[0], slot), depth + 1)
        else:
            """ We have reached a terminal leaf, i.e., and field with an actual value attached.
                    Just print the name at this point.
            """
            print(' ' * (depth * 2) + field_name)

    def save_mat(self, save_to_file_='rosbag.mat'):
        sio.savemat(save_to_file_, {'data': self.data})

    def save_pickle(self, save_to_file_='rosbag.p'):
        pickle.dump({'data': self.data}, open(save_to_file_, "wb"))

    def parse_topic(self, i):
        tic()
        topic_ = self.approved_topics[i]
        _dict = self.data[topic_.replace("/", "_")[1:]]
        print('processing \033[0;34m'+topic_+'\033[0m')
        bagged_time = []
        for topic, msg, bt in self.bag.read_messages(topics=[self.approved_topics[i], 'numbers']):
            BagReader.append_msg(_dict, msg)
            bagged_time.append(bt.to_sec())
        self.data[topic_.replace("/", "_")[1:]] = _dict
        self.data[topic_.replace("/", "_")[1:]
                  ]['bagged_time'] = bagged_time
        _dict = None
        toc()

    def read(self, _args=None):
        import rosbag
        import yaml
        import subprocess
        import copy
        import threading
        print(self)

        yaml_info = yaml.load(subprocess.Popen(['rosbag', 'info', '--yaml', self.file],
                                               stdout=subprocess.PIPE).communicate()[0])
        numRowsData = 0
        for t in yaml_info['topics']:
            numRowsData += t['messages']

        self.approved_topics = []
        # identifying the message types
        for i in range(len(self.topics)):
            for topic, msg, _ in self.bag.read_messages(topics=[self.topics[i], 'numbers']):
                if msg._type in self.ignore_msg_type_:
                    print('Skipping \033[0;33m'+topic + '\033[0m; ' + '\033[0;31m' +
                          msg._type + '\033[0m msg type is not supported')
                elif topic in self.ignore_msg_topics_:
                    print('Skipping topic \033[0;33m'+topic + '\033[0m; ')
                else:
                    self.data[topic.replace(
                        "/", "_")[1:]] = self.identify_topic_fields(topic, msg, 0)
                    self.approved_topics.append(self.topics[i])
                break

        # inputs = [i for i in range(len(self.approved_topics))]
        # pool = multiprocessing.Pool(processes=4)
        # results = pool.map(parse_topic, inputs)
        # pool.close()
        # pool.join()

        # for i in range(len(approved_topics)):  # TODO: parallelize this conversion
        #     self.data[approved_topics[i].replace("/", "_")[1:]], self.data[approved_topics[i].replace("/", "_")[1:]]['bagged_time'] = parse_topic((approved_topics[i], self.bag.read_messages(
        #         topics=[approved_topics[i], 'numbers'])))

        start_time = time.time()
        for i in range(len(self.approved_topics)):
            self.parse_topic(i)
        # threads = []
        # for i in range(len(self.approved_topics)):
        #     threads.append(threading.Thread(
        #         target=self.parse_topic, args=(i,)))

        # for t in threads:
        #     t.start()
        # for t in threads:
        #     t.join()

        end_time = time.time()
        print("total time: {}".format(end_time-start_time))


def convert_bag(filename, args):
    # read ros-bag file
    ros_bag_ = BagReader(filename)
    if args['ignore_msgs'] is not None:
        ros_bag_.ignore_msg_type(args['ignore_msgs'])
    if args['ignore_topics'] is not None:
        ros_bag_.ignore_msg_topic(args['ignore_topics'])

    # read rosbag
    ros_bag_.read()

    # saving the data to *.mat file
    if args['mat']:
        mat_file_name = os.path.splitext(filename)[0]+'.mat'
        print('Saving to mat file '+mat_file_name)
        ros_bag_.save_mat(mat_file_name)
    else:
        pickle_file_name = os.path.splitext(filename)[0]+'.p'
        print('Saving to pickle file '+pickle_file_name)
        ros_bag_.save_pickle(pickle_file_name)


def look_for_bag_files(full_paths, fileExt2LookFor='.bag', recursive=False):
    files = set()
    for path in full_paths:
        if os.path.isfile(path):
            fileName, fileExt = os.path.splitext(path)
            if fileExt2LookFor == '' or fileExt2LookFor == fileExt:
                files.add(path)
        else:
            if (recursive):
                full_paths += glob.glob(path + '/*')
    return files


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Read in a file or set of files, and return the result.',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-p', '--path', nargs='+', default='.',
                        help='Path of a file or a folder of files.')
    parser.add_argument('-t', '--topic', nargs='+', default='.', help="topics to debag")  

    parser.add_argument('-im', '--ignore_msgs', type=str, nargs='+',
                        help='ros message types to be ignored')
    parser.add_argument('-it', '--ignore_topics', type=str, nargs='+',
                        help='ros topics to be ignored')
    parser.add_argument('-r', '--recursive', action='store_true',
                        default=False, help='Search through subfolders')
    parser.add_argument('-m', '--mat', default=False, action='store_true',
                        help='Search through subfolders')

    args = parser.parse_args()
    args_dict = vars(args)
    # Parse paths
    full_paths = [os.path.normpath(os.path.join(
        os.getcwd(), path)) for path in args.path]

    bag_files = look_for_bag_files(
        full_paths, fileExt2LookFor='.bag', recursive=args.recursive)

    pkld_files = look_for_bag_files(
        full_paths, fileExt2LookFor='.p', recursive=args.recursive)

    print("Found " + str(len(bag_files)) + " bag files and " +
          str(len(pkld_files)) + " pickled files!")

    for bagfile in bag_files:
        if (os.path.splitext(bagfile)[0]+'.p' in pkld_files):
            print(bagfile + ' is already pickled; skipping..')
        else:
            print('converting \033[0;34m'+bagfile+'\033[0m to pickle')
            convert_bag(bagfile, args_dict)

    pass
