#!/usr/bin/env python3
"""
Setup script for Awesome Cyber Bot
Install with: pip install .
"""

from setuptools import setup, find_packages
import os
import sys

# Read requirements
with open('requirements.txt', 'r') as f:
    requirements = [line.strip() for line in f if line.strip() and not line.startswith('#')]

# Read README
readme_file = 'README.md'
if os.path.exists(readme_file):
    with open(readme_file, 'r', encoding='utf-8') as f:
        long_description = f.read()
else:
    long_description = "Awesome Cyber Bot - Ultimate Cybersecurity Tool"

setup(
    name='awesome-cyber-bot',
    version='1.0.0',
    author='Ian Carter Kulani',
    description='Ultimate cybersecurity tool with 3000+ commands',
    long_description=long_description,
    long_description_content_type='text/markdown',
    url='https://github.com/awesome-cyber-bot/awesome-cyber-bot',
    packages=find_packages(),
    classifiers=[
        'Development Status :: 4 - Beta',
        'Intended Audience :: Information Technology',
        'Intended Audience :: System Administrators',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
        'Programming Language :: Python :: 3.11',
        'Topic :: Security',
        'Topic :: System :: Networking',
    ],
    python_requires='>=3.7',
    install_requires=requirements,
    entry_points={
        'console_scripts': [
            'awesome-cyber-bot=awesome_cyber_bot:main',
            'acb=awesome_cyber_bot:main',
        ],
    },
    include_package_data=True,
    zip_safe=False,
)