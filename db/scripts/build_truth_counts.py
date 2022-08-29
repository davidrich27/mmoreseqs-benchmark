#!/usr/bin/env python
###############################################################################
#  FILE:  build_truth_tbl.py
#  DESC:  Build truth table from file of targets and decoys.
###############################################################################

import os
import sys
import numpy as np

query_name_file = "pmark.query.names"
target_real_file = "pmark.target_reals.names"
target_fake_file = "pmark.target_decoys.names"

query_fp = open(query_name_file, "r")
target_fp = open(target_real_file, "r")
fakes_fp = open(target_fake_file, "r")

counts = {}
counts["T"] = 0
counts["F"] = 0
counts["?"] = 0

query_names = []
target_names = []
fake_names = []

# load queries
for line in query_fp:
    fields = line.split()
    query_names.append(fields[0])
query_fp.close()

# load target reals
for line in target_fp:
    fields = line.split()
    target_names.append(fields[0])
target_fp.close()

# load target decoys
for line in fakes_fp:
    fields = line.split()
    fake_names.append(fields[0])
fakes_fp.close()

# all decoys are false positives
counts["F"] += (len(fake_names) * len(query_names))

# compare queries and targets
for query in query_names:
    for target in target_names:
        target_root = target.split("/")[0]
        if target_root == query:
            counts["T"] += 1
        # elif target.startswith("decoy"):
        #	counts["F"] += 1
        else:
            counts["?"] += 1

# report totals
print("# TP {}".format(counts["T"]))
print("# FP {}".format(counts["F"]))
print("# ?? {}".format(counts["?"]))
