#!/usr/bin/env python
##################################################################################
#	 NAME: 	mod_msa_ac2id.py
#  DESC:  Convert MSA from using AC field to ID field.
##################################################################################

import sys

if len(sys.argv) != 3:
    print("# Usage: <msa_in> <msa_out>")
    exit()

msa_in = sys.argv[1]
msa_out = sys.argv[2]

fp_in = open(msa_in, 'r')
fp_out = open(msa_out, 'w')
line = fp_in.readline()

id2ac = {}

while line:
    line

    if line.startswith("#=GF ID"):
        fields = line.split()
        id = fields[2]
        fp_out.write(line)

    elif line.startswith("#=GF AC"):
        fields = line.split()
        newline = "{} {} {}\n".format(fields[0], fields[1], id)
        fp_out.write(newline)

    else:
        fp_out.write(line)

    # get next line
    line = fp_in.readline()

fp_in.close()
fp_out.close()
