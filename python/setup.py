# setup.py
from setuptools import setup

setup(
    name='utils',
    version='0.1.0',
    packages=['utils'],
    install_requires=[
        "scipy", 
        "matplotlib",
        "numpy",
        "seaborn",
        "ipython",
        "quadprog",
        "pyrosbag",
        "argparse",
        "pathlib",
        "pandas",
        "pycryptodome"
    ],
)