#!/usr/bin/env python3
import sys

log_file = open(sys.argv[1],'r').readlines()

correct_launch = log_file[0].find("====") != -1 and log_file[1].find("process has finished cleanly") != -1

if not correct_launch:
    print("launch has been finished incorrectly")