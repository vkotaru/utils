import os, sys, glob
import IPython

import rosbag
import time 

import numpy as np
import scipy.io as sio
import matplotlib.pyplot as plt


class BagExtractor(object):
    """docstring for BagExtractor"""
    def __init__(self, arg):
        super(BagExtractor, self).__init__()

        self.bagname = arg
        self.i = 0
        self.pos = []
        self.vel = []
        self.euler = []
        self.posd = []
        self.veld = []
        self.F = []

        self.onflag = []
        self.onflag_flag = 0

        self.yaw = []
        self.tracking = []

        self.t_ = np.array([])
        self.t2_ = np.array([])
        self.t3_ = np.array([])
        self.tq1_ = np.array([])

    def read(self):
        bag = rosbag.Bag(self.bagname)

        for topic, msg, t in bag.read_messages(topics=['/onboard/control_flags','numbers']):
            self.onflag_flag=1
            self.onflag.append(np.array([msg.ONBOARD_CONTROL_FLAG]))
            self.t3_ = np.append(self.t3_, (t.secs+t.nsecs*1e-9))

        if (self.onflag_flag==0):
            for topic, msg, t in bag.read_messages(topics=['/control_flags','numbers']):
                self.onflag.append(np.array([msg.ONBOARD_CONTROL_FLAG]))
                self.t3_ = np.append(self.t3_, (t.secs+t.nsecs*1e-9))

        for topic, msg, t in bag.read_messages(topics=['/optitrack/autel_des_pose','numbers']):
            # IPython.embed()
            self.F.append(np.array([msg.F_geo.x, msg.F_geo.y, msg.F_geo.z]))

        for topic, msg, t in bag.read_messages(topics=['/optitrack/odometry/autel_act_pose', 'numbers']):
            # print msg
            self.pos.append(np.array([msg.position.x, msg.position.y, msg.position.z]))
            self.vel.append(np.array([msg.vel.x, msg.vel.y, msg.vel.z]))
            self.euler.append(np.array([msg.euler.x, msg.euler.y, msg.euler.z]))
            self.tracking.append(np.array([msg.tracking_valid]))
            self.t_ = np.append(self.t_, (t.secs+t.nsecs*1e-9))

        for topic, msg, t in bag.read_messages(topics=['/quad_ros/desired_pose', 'numbers']):
            # print msg
            self.posd.append(np.array([msg.position.x, msg.position.y, msg.position.z]))
            self.veld.append(np.array([msg.velocity.x, msg.velocity.y, msg.velocity.z]))
            self.t2_ = np.append(self.t2_, (t.secs+t.nsecs*1e-9))

        bag_dict = {'onflag':self.onflag,'time3':self.t3_,'F':self.F,'pos':self.pos, 'vel':self.vel, 'euler':self.euler, 'time':self.t_, 'posd':self.posd, 'veld':self.veld, 'time2':self.t2_,'tracking':self.tracking}
        bag_file_basename = os.path.basename(self.bagname)
        mat_file_basename = os.path.splitext(bag_file_basename)[0]+'.mat'
        mat_filename = os.path.join('./experiments_mat_folder',mat_file_basename)
        sio.savemat(mat_filename,bag_dict)
        bag.close()


if __name__ == '__main__':

    walk_dir = sys.argv[1]

    print('walk_dir (absolute) = ' + os.path.abspath(walk_dir))
    arg_dir = os.path.abspath(walk_dir)

    for root, subdirs, files in os.walk(walk_dir):
        print('--\nroot = ' + root )
        list_file_path = os.path.join(root, '*.bag')
        rosbag_files = glob.glob(list_file_path)

        for bag_file_name in rosbag_files:
            print('\t'+bag_file_name)
            be = BagExtractor(bag_file_name)
            be.read()


############## end

        # with open(list_file_path, 'wb') as list_file:
        #     for subdir in subdirs:
        #         print('\t- subdirectory ' + subdir)

        #     for filename in files:
        #         file_path = os.path.join(root, filename)

        #         print('\t- file %s (full path: %s)' % (filename, file_path))

        #         with open(file_path, 'rb') as f:
        #             f_content = f.read()
        #             list_file.write(('The file %s contains:\n' % filename).encode('utf-8'))
        #             list_file.write(f_content)
        #             list_file.write(b'\n')
