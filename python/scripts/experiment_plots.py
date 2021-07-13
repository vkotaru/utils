#!/usr/bin/python2
"""@package bag2mat
script to convert a list of bag files to mat files
"""
import argparse
import pathlib
import utils
import os
import scipy.io as sio
import seaborn as sns
import matplotlib.pyplot as plt
import pickle
import numpy as np

def main_plots():
    parser = argparse.ArgumentParser()
    parser.add_argument('-b', '--bag', nargs=1, help='Bag filename')
    parser.add_argument('-p', '--pickle', nargs=1,
                        help='Pre-saved pickle file')
    args = parser.parse_args()
    if not (args.bag or args.pickle):
        parser.error('No argument given, either --bag(-b) or --pickle(-p)')

    if args.bag is not None:
        bag_ = utils.ros.BagReader(args.bag[0])
        bag_.read()
        data = bag_.data
        with open(os.path.splitext(args.bag[0])[0] + '.pickle', 'wb') as handle:
            pickle.dump(data, handle, protocol=pickle.HIGHEST_PROTOCOL)

    if args.pickle is not None:
        with open(args.pickle[0], 'rb') as handle:
            data = pickle.load(handle)

    # plot the pose info
    red_falcon_odom = utils.ros.OdomPlotter.extract_position(data['red_falcon_odometry_mocap'])
    t0 = red_falcon_odom['t'][0]
    red_falcon_odom['t'] = red_falcon_odom['t']-t0

    blue_falcon_odom = utils.ros.OdomPlotter.extract_position(data['blue_falcon_odometry_mocap'])
    blue_falcon_odom['t'] = blue_falcon_odom['t']-t0

    tf = red_falcon_odom['t'][-1]

    plt.figure(1)
    plt.subplot(311)
    plt.plot(red_falcon_odom['t'], red_falcon_odom['x'], 'k', LineWidth=2, linestyle='-')
    plt.plot(blue_falcon_odom['t'], blue_falcon_odom['x'], 'k', LineWidth=2, linestyle=':')
    plt.xlim(0, tf)
    plt.ylim(-1, 1.)
    plt.ylabel(r'$x~[m]$', fontsize=15)

    plt.subplot(312)
    plt.style.use('seaborn-whitegrid')
    plot_mean_std(pos_est['t'], pos_est['y'], pos_est['y_std'])
    plt.plot(pos_true['t'], pos_true['y'], 'k', LineWidth=2, linestyle=':')
    plt.xlim(0, tf)
    plt.ylim(-1.5, 0.5)
    plt.ylabel(r'$y~[m]$', fontsize=15)

    plt.subplot(313)
    plt.style.use('seaborn-whitegrid')
    plot_mean_std(pos_est['t'], pos_est['z'], pos_est['z_std'])
    plt.plot(pos_true['t'], pos_true['z'], 'k', LineWidth=2, linestyle=':')
    plt.xlim(0, tf)
    plt.ylim(-0.25, 1.5)
    plt.ylabel(r'$z~[m]$', fontsize=15)
    plt.xlabel(r'$ \texttt{time } [s]$', fontsize=15)
    plt.show()

    if 'dega_base_imu_raw' in data.keys():
        plt.figure(2)
        plot_imu(data['dega_base_imu_raw'])
        plt.show()
    else:
        print("skipping dega_base_imu_raw")
    # plt.ylim(-1, 1)

    pass


if __name__ == "__main__":
    main_plots()
