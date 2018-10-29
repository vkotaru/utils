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
    def __init__(self,_bag_name=None):
        super(BagReader, self).__init__()
        
        self.name   = None
        self.bag    = None
        self.topics = None

        self.data = {}

        if _bag_name == None:
            warnings.warn("bag filename is missing", UserWarning)
        else:
            self.update(_bag_name)

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
        # if arg == 'all':
        #     parse_only_ = range(len(self.topics))
        # else:
        #     parse_only_ = arg

        # for i  in parse_only_:
        #     if self.topics[i] == '/qrotor_offboard/odometry':
        #         print "Reading topic " + self.topics[i] + '\n'
        #         tmp = {}
        #         tmp['position'] = []
        #         tmp['velocity'] = []
        #         tmp['euler']    = []
        #         tmp['time']     = []
        #         for topic, msg, t in self.bag.read_messages(topics=[self.topics[i],'numbers']):
        #             tmp['time'].append(np.array([t.secs+t.nsecs*1e-9]))
        #             tmp['position'].append(np.array([msg.position.x,
        #                                                 msg.position.y,
        #                                                 msg.position.z]))
        #             tmp['velocity'].append(np.array([msg.velocity.x,
        #                                                 msg.velocity.y,
        #                                                 msg.velocity.z]))
        #             tmp['euler'].append(np.array([msg.euler_angles.x,
        #                                                 msg.euler_angles.y,
        #                                                 msg.euler_angles.z]))
        #         topic_name_ = self.topics[i].replace("/", "_")    
        #         self.bag_data_[topic_name_[1:]] = tmp
                
        #     if self.topics[i] == '/qrotor_onboard/linear_accel_world':
        #         print "Reading topic " + self.topics[i] + '\n'
        #         tmp = {}
        #         tmp['accel'] = []
        #         tmp['time']     = []
        #         for topic, msg, t in self.bag.read_messages(topics=[self.topics[i],'numbers']):
        #             tmp['time'].append(np.array([t.secs+t.nsecs*1e-9]))
        #             tmp['accel'].append(np.array([msg.x, msg.y, msg.z]))
        #         topic_name_ = self.topics[i].replace("/", "_")    
        #         self.bag_data_[topic_name_[1:]] = tmp

        #     if self.topics[i] == '/qrotor_onboard/attitude':
        #         print "Reading topic " + self.topics[i] + '\n'
        #         tmp = {}
        #         tmp['data'] = []
        #         tmp['time']     = []
        #         for topic, msg, t in self.bag.read_messages(topics=[self.topics[i],'numbers']):
        #             tmp['time'].append(np.array([t.secs+t.nsecs*1e-9]))
        #             tmp['data'].append(np.array([msg.roll, msg.pitch, msg.yaw, msg.gx, msg.gy, msg.gz]))
        #         topic_name_ = self.topics[i].replace("/", "_")    
        #         self.bag_data_[topic_name_[1:]] = tmp

    def save_to(self,save_to_file_='rosbag.mat'):
        sio.savemat(save_to_file_,self.bag_data_)





