#!/usr/bin/env python2
"""
bag_reader to a read and parse a rosbag
TODO: (find and cite the original source)
"""

import rosbag 
import os, sys, time, math, glob 
import warnings
import numpy as np
from rosbag.bag import Bag
import scipy as sp 
import matplotlib as plt

class BagReader(object):
    def __init__(self, _file=None, _args=None):
        super(BagReader, self).__init__()

        self.file = None
        self.bag = None
        self.topics = None
        self.data = {}
        
        if _file == None:
            warnings.warn("bag filename is missing", UserWarning)
        else:
            self.update(_file)

    def update(self, _file):
        self.file = _file
        self.bag = self.get_bag(self.file)
        self.topics = self.get_topics(self.bag)

    @staticmethod
    def get_topics(bag):
        return bag.get_type_and_topic_info()[1].keys()

    @staticmethod
    def get_bag(filename):
        return rosbag.Bag(filename)
        
    def clear(self):
        self.name   = None
        self.bag    = None
        self.topics = None
        self.data   = {}

    def __str__(self):
        str = 'List of Topics in the bag:\n'
        for i in range(len(self.topics)):
            str = str + '\t' +  self.topics[i] + '\n'
        return str


    def read(self, _args):
        pass

    @staticmethod
    def identify_topic_fields(field_name, msg, depth):
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
            d = {}
            for slot in msg.__slots__:
                d[slot] = BagReader.identify_topic_fields(slot, getattr(msg, slot), depth + 1)
            return d
        elif isinstance(msg, list):
            """ We found a vector of field names. Display the information on the current
                    level, and use the first element of the vector to display information
                    about its content
            """
            if (len(msg) > 0) and hasattr(msg[0], '__slots__'):
                print(' ' * (depth * 2) + field_name + '[]')
                l = []
                for slot in msg[0].__slots__:
                    l.append(BagReader.identify_topic_fields(slot, getattr(msg[0], slot), depth + 1))
                return {field_name: l}
        else:
            """ We have reached a terminal leaf, i.e., and field with an actual value attached.
                    Just print the name at this point.
            """
            print(' ' * (depth * 2) + field_name)
            return []


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
                BagReader.print_topic_fields(slot, getattr(msg, slot), depth + 1)
        elif isinstance(msg, list):
            """ We found a vector of field names. Display the information on the current
                    level, and use the first element of the vector to display information
                    about its content
            """
            if (len(msg) > 0) and hasattr(msg[0], '__slots__'):
                print(' ' * (depth * 2) + field_name + '[]')
                for slot in msg[0].__slots__:
                    BagReader.print_topic_fields(slot, getattr(msg[0], slot), depth + 1)
        else:
            """ We have reached a terminal leaf, i.e., and field with an actual value attached.
                    Just print the name at this point.
            """
            print(' ' * (depth * 2) + field_name)
