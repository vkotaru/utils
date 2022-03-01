#!/usr/bin/env python2
"""
bag_reader to read and parse a rosbag
TODO: (find and cite the original source to the print_topic_fields function)
"""

import rosbag
import os
import sys
import time
import math
import glob
import warnings
import numpy as np
from rosbag.bag import Bag
import scipy as sp
import matplotlib as plt
import scipy.io as sio
import IPython as ip
import pickle


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


def convert_bag(_file, params=None):
    """
    function to read a bag file and save the data to a mat file
    for instance, 
    /path/to/file.bag is converted to /path/to/file.mat
    @param [in] _file file name as a string
    @param [in] ignore_msgs_ list of message types to be ignored during the conversion
    """
    # read ros-bag file
    ros_bag_ = BagReader(_file.name)
    if params['ignore_msgs'] is not None:
        ros_bag_.ignore_msg_type(params['ignore_msgs'])

    # read rosbag
    ros_bag_.read()

    # saving the data to *.mat file
    if params['save_pickle']:
        pickle_file_name = os.path.splitext(_file.name)[0]+'.p'
        print('Saving to pickle file '+pickle_file_name)
        ros_bag_.save_pickle(pickle_file_name)
    else:
        mat_file_name = os.path.splitext(_file.name)[0]+'.mat'
        print('Saving to mat file '+mat_file_name)
        ros_bag_.save_to(mat_file_name)


class BagReader(object):
    def __init__(self, _file=None, _args=None):
        super(BagReader, self).__init__()

        self.file = None
        self.bag = None
        self.topics = None
        self.data = {}
        self.ignore_msg_type_ = ['sensor_msgs/CameraInfo',
                                 'sensor_msgs/Image',
                                 'rosgraph_msgs/Log',
                                 'tf2_msgs/TFMessage',
                                 'dynamic_reconfigure/ConfigDescription',
                                 'dynamic_reconfigure/Config',
                                 'std_msgs/Float64MultiArray']

        if _file == None:
            warnings.warn("bag filename is missing", UserWarning)
        else:
            self.update(_file)

    def update(self, _file):
        self.file = _file
        self.bag = self.get_bag(self.file)
        self.topics = self.get_topics(self.bag)

    def ignore_msg_type(self, msg_type_):
        if isinstance(msg_type_, list):
            for i in len(msg_type_):
                self.ignore_msg_type_.append(msg_type_[i])
        else:
            self.ignore_msg_type_.append(msg_type_)

    def approve_msg_type(self, msg_type_):
        # TODO: find if msg_type_ is in ignore_msg_type_ and remove it if yes
        pass

    @staticmethod
    def get_topics(bag):
        return list(bag.get_type_and_topic_info()[1].keys())

    @staticmethod
    def get_bag(filename):
        return rosbag.Bag(filename)

    def clear(self):
        self.name = None
        self.bag = None
        self.topics = None
        self.data = {}

    def __str__(self):
        str = 'List of Topics in the bag:\n'
        for i in range(len(self.topics)):
            str = str + '\t' + self.topics[i] + '\n'
        return str

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
                if (len(msg) > 0) and hasattr(msg[0], '__slots__'):
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

    def save_to(self, save_to_file_='rosbag.mat'):
        sio.savemat(save_to_file_, {'data': self.data})

    def save_pickle(self, save_to_file_='rosbag.p'):
        pickle.dump({'data': self.data}, open(save_to_file_, "wb"))

    def read(self, _args=None):
        print(self)
        approved_topics = []
        # identifying the message types
        for i in range(len(self.topics)):
            for topic, msg, _ in self.bag.read_messages(topics=[self.topics[i], 'numbers']):
                if not msg._type in self.ignore_msg_type_:
                    # self.print_topic_fields(topic, msg, 0)
                    self.data[topic.replace(
                        "/", "_")[1:]] = self.identify_topic_fields(topic, msg, 0)
                    approved_topics.append(self.topics[i])
                else:
                    print('\033[0;31m'+msg._type + '\033[0m msg type is not supported\n' +
                          '\033[0;33m'+topic + '\033[0m is skipped from converting to mat file')
                break

        # reading and converting approved topics
        for i in range(len(approved_topics)):  # TODO: parallelize this conversion
            tic()
            topic_ = approved_topics[i]
            _dict = self.data[topic_.replace("/", "_")[1:]]
            print('processing \033[0;34m'+topic_+'\033[0m')
            for topic, msg, _ in self.bag.read_messages(topics=[topic_, 'numbers']):
                self.append_msg(_dict, msg)
            self.data[topic_.replace("/", "_")[1:]] = _dict
            _dict = None
            toc()
        pass
