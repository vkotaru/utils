#!/usr/bin/env python
"""Bag reader.

This module reads all the rosmgs in a given a ros bag file. 

# Example:
#     Examples can be given using either the ``Example`` or ``Examples``
#     sections. Sections support any reStructuredText formatting, including
#     literal blocks::

#         $ python example_google.py

# Section breaks are created by resuming unindented text. Section breaks
# are also implicitly created anytime a new section starts.

# Attributes:
#     module_level_variable1 (int): Module level variables may be documented in
#         either the ``Attributes`` section of the module docstring, or in an
#         inline docstring immediately following the variable.

#         Either form is acceptable, but the two should not be mixed. Choose
#         one convention to document module level variables and be consistent
#         with it.

Todo:
    * Update this docstring

"""

import rospy, rosbag
import os, sys, time, math, glob
import warnings

import numpy as np
import scipy.io as sio
# import matplotlib.pyplot as plt

class BagReader(object):
    """
    Function to read a rosbag and convert it into a mat file
    """
    def __init__(self,_bag_name=None, _arg=None):
        super(BagReader, self).__init__()
        
        self.name   = None
        self.bag    = None
        self.topics = None

        self.data = {}

        if _bag_name == None:
            warnings.warn("bag filename is missing", UserWarning)
            if _arg == 'read' or _arg == 'save':
                warnings.warn("bag is NOT read", UserWarning)
        else:
            self.update(_bag_name)
            if _arg == 'read':
                self.read()

    def update(self, _bag_name):  
        self.name   = _bag_name
        self.bag    = rosbag.Bag(self.name)
        self.topics = self.bag.get_type_and_topic_info()[1].keys()

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

    def read(self,arg='all'):
        print('to do!')
        if arg == 'all':
            parse_index = range(len(self.topics))
        else:
            parse_index = arg

        for i in parse_index:
                print "Reading topic " + self.topics[i] + '\n'
                tmp = {}

                for topic, msg, _ in self.bag.read_messages(topics=[self.topics[i],'numbers']):
                    """ Recursively list the fields in each message """
                    self.print_topic_fields(topic['topic'], msg, 0)
                    break

                tmp['accel'] = []
                tmp['time']     = []
                for topic, msg, t in self.bag.read_messages(topics=[self.topics[i],'numbers']):
                    tmp['time'].append(np.array([t.secs+t.nsecs*1e-9]))
                    tmp['accel'].append(np.array([msg.x, msg.y, msg.z]))

                # renaming the topic for matlab    
                topic_name_ = self.topics[i].replace("/", "_")    
                self.data[topic_name_[1:]] = tmp


                for topic, msg, t in self.bag.read_messages(topics=[self.topics[i],'numbers']):
                    self.print_topic_fields(topic, msg, 0)
                    print("i'm here")
  

    def print_topic_fields(self,field_name, msg, depth):
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
                self.print_topic_fields(slot, getattr(msg, slot), depth + 1)
        elif isinstance(msg, list):
            """ We found a vector of field names. Display the information on the current
                    level, and use the first element of the vector to display information
                    about its content
            """
            if (len(msg) > 0) and hasattr(msg[0], '__slots__'):
                print(' ' * (depth * 2) + field_name + '[]')
                for slot in msg[0].__slots__:
                    self.print_topic_fields(slot, getattr(msg[0], slot), depth + 1)
        else:
            """ We have reached a terminal leaf, i.e., and field with an actual value attached.
                    Just print the name at this point.
            """
            print(' ' * (depth * 2) + field_name)

    def save_to(self,save_to_file_='rosbag.mat'):
        sio.savemat(save_to_file_,self.data)


if __name__ == '__main__':
    print('to do: adding argument parser')


