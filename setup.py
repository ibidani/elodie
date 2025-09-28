#!/usr/bin/env python
"""
Setup script for Elodie - Your Personal EXIF-based Photo, Video and Audio Assistant
"""

import os
from setuptools import setup, find_packages

# Read the contents of README file
this_directory = os.path.abspath(os.path.dirname(__file__))
with open(os.path.join(this_directory, 'Readme.md'), encoding='utf-8') as f:
    long_description = f.read()

# Read requirements
with open(os.path.join(this_directory, 'requirements.txt'), encoding='utf-8') as f:
    requirements = [line.strip() for line in f if line.strip() and not line.startswith('#')]

setup(
    name='elodie',
    version='1.0.0',
    description='Your Personal EXIF-based Photo, Video and Audio Assistant',
    long_description=long_description,
    long_description_content_type='text/markdown',
    author='Jaisen Mathai',
    author_email='jaisen@jmathai.com',
    url='https://github.com/jmathai/elodie',
    packages=find_packages(),
    include_package_data=True,
    install_requires=requirements,
    python_requires='>=3.6',
    entry_points={
        'console_scripts': [
            'elodie=elodie:main',
        ],
    },
    classifiers=[
        'Development Status :: 4 - Beta',
        'Intended Audience :: End Users/Desktop',
        'License :: OSI Approved :: ISC License (ISCL)',
        'Operating System :: OS Independent',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
        'Programming Language :: Python :: 3.11',
        'Topic :: Multimedia :: Graphics',
        'Topic :: Multimedia :: Video',
        'Topic :: Multimedia :: Sound/Audio',
        'Topic :: System :: Archiving',
        'Topic :: Utilities',
    ],
    keywords='exif photo video audio organization metadata',
    project_urls={
        'Documentation': 'https://github.com/jmathai/elodie/blob/master/Readme.md',
        'Source': 'https://github.com/jmathai/elodie',
        'Tracker': 'https://github.com/jmathai/elodie/issues',
    },
)