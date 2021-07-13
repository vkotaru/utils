#!/usr/bin/python2
import argparse
import pathlib
import utils
import os
import scipy.io as sio
import seaborn as sns
import matplotlib.pyplot as plt
import pickle
import numpy as np
plt.rcParams.update({
    "text.usetex": True,
    "font.family": "sans-serif",
    "font.sans-serif": ["Helvetica"]})
## for Palatino and other serif fonts use:
plt.rcParams.update({
    "text.usetex": True,
    "font.family": "serif",
    "font.serif": ["Palatino"],
})


def plot_imu(imu):
    imu['t'] = header_to_time(imu['header'])
    t_ = imu['t'][0]
    imu['t'] = imu['t']-t_
    tf = imu['t'][-1]

    plt.subplot(321)
    plot_xy(imu['t'], imu['angular_velocity']['x'], xLim=(0, tf), yLim=(-3,3))

    plt.subplot(322)
    plot_xy(imu['t'], imu['linear_acceleration']['x'], xLim=(0, tf), yLim=(-3,3))

    plt.subplot(323)
    plot_xy(imu['t'], imu['angular_velocity']['y'], xLim=(0, tf), yLim=(-3,3))

    plt.subplot(324)
    plot_xy(imu['t'], imu['linear_acceleration']['y'], xLim=(0, tf), yLim=(-3,3))

    plt.subplot(325)
    plot_xy(imu['t'], imu['angular_velocity']['z'], xLim=(0, tf), yLim=(-3,3))

    plt.subplot(326)
    plot_xy(imu['t'], imu['linear_acceleration']['z'], xLim=(0, tf), yLim=(-1,12))

class OdomPlotter(object):
    """
    Module to plot odometry info along with standard-deviation
    """
    def __init__(self):
        pass

    @staticmethod
    def extract_position(_dict_in):
        _dict_out = {
            't': np.array(_dict_in['header']['stamp']['secs'], float) + np.array(_dict_in['header']['stamp']['nsecs'],
                                                                                 float) * 1e-9,
            'x': np.array(_dict_in['pose']['pose']['position']['x'], float),
            'y': np.array(_dict_in['pose']['pose']['position']['y'], float),
            'z': np.array(_dict_in['pose']['pose']['position']['z'], float)}

        pose_covar = np.array(_dict_in['pose']['covariance'], float)

        _dict_out['x_std'] = np.sqrt(pose_covar[:, 0])
        _dict_out['y_std'] = np.sqrt(pose_covar[:, 7])
        _dict_out['z_std'] = np.sqrt(pose_covar[:, 14])

        return _dict_out