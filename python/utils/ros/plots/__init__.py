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
from . import odometry

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

def header_to_time(header):
    return np.array(header['stamp']['secs'], float) + np.array(header['stamp']['nsecs'], float) * 1e-9

def plot_xy(x, y, xLim=None, yLim=None):
    plt.style.use('seaborn-whitegrid')
    plt.plot(x, y, 'r', LineWidth=1)
    if xLim is not None:
        plt.xlim(xLim[0], xLim[1])
    if yLim is not None:
        plt.ylim(yLim[0], yLim[1])
    plt.grid(b=True, which='major', color='#666666', linestyle='-')
    plt.minorticks_on()
    plt.grid(b=True, which='minor', color='#999999', linestyle=':')

def plot_mean_std(x, y_mean, y_std_dev):
    plt.style.use('seaborn-whitegrid')
    plt.plot(x, y_mean, 'r', LineWidth=1)
    plt.fill_between(x, y_mean-3*y_std_dev,
                     y_mean + 3*y_std_dev, color='red', alpha=0.2)
    plt.grid(b=True, which='major', color='#666666', linestyle='-')
    plt.minorticks_on()
    plt.grid(b=True, which='minor', color='#999999', linestyle=':')
