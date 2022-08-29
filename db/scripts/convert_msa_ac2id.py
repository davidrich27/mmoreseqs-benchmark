#!/usr/bin/python
##################################################################################
#	 NAME:  convert_msa_ac2id.py
#  DESC:  Convert MSA from using AC field to ID field.
##################################################################################

import sys

if len(sys.argv) != 4:
    print("# Usage: <msa_in> <results_in> <results_out>")
    exit()

msa_in = sys.argv[1]
results_in = sys.argv[2]
results_out = sys.argv[3]

fp = open(msa_in, 'r')
line = fp.readline()

id2ac = {}

while line:
    line = line.strip()
    fields = line.split()

    if fields[0] == "#=GF":
        if fields[1] == "ID":
            msa_id = fields[2]
        if fields[1] == "AC":
            msa_ac = fields[2]
            id2ac[msa_ac] = msa_id

    line = fp.readline()

ac_fp.close()
id_fp.close()

results_fp.open(results_in, 'r')
results_line = results_fp.readline()


while line:
    line = line.strip()
    fields = line.split()
