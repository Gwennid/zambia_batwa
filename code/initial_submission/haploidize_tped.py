#!/usr/bin/env python

from numpy.random import randint
import sys

##read tped from stdin and make all sites homozygous

for l in sys.stdin:
	split=l.rstrip().split()
	for i in xrange(4,len(split),2):
		a=split[i+randint(0,2)]
		split[i]=a
		split[i+1]=a
	print ' '.join(split)
