#!/usr/bin/env python

from  python_utils.bag_reader import *

filename = '/home/venkata/workspace/qrotor_ws/bags/pos_experiments/2018-06-25-18-33-20.bag'
bg = BagReader(filename)

print(bg)
bg.read()
save_to_file = '/home/venkata/workspace/qrotor_ws/bags/pos_experiments/2018-06-25-18-33-20.mat'
bg.save_to(save_to_file)