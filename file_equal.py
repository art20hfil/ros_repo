#!/usr/bin/env python3

# argv[1] - path to the first file
# argv[2] - path to the second file
# argv[3] - error message
import sys

lst1 = open(sys.argv[1],'r').read()
lst2 = open(sys.argv[2],'r').read()

are_equal = len(lst1) == len(lst2)

for item in lst1:
    are_equal = are_equal and (item in lst2)

for item in lst2:
    are_equal = are_equal and (item in lst1)

if not are_equal:
    print(sys.argv[3])
