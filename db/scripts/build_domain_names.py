#!/bin/usr/env python
#####################################################################
#  FILE:  build_truth_domain_tbl.py
#  DESC:  Build table of domains with ids
#####################################################################

import os
import sys
import numpy as np

# load names file


def load_names(filename):
    # dictionaries
    name2id = {}
    id2name = {}
    # open .names file
    fp = open(filename, "r")
    for line in fp:
        # parse fields
        fields = line.split()
        myid = fields[0]
        myname = fields[1]
        # add to dicts
        name2id[myname] = myid
        id2name[myid] = myname
    # close file
    fp.close()
    return name2id, id2name

# add domains from accession file to list


def add_acc_to_domains(filename, dom_list):
    # open .acc file
    fp = open(filename, "r")
    for line in fp:
        # section breaks on |
        sections = line.split("|")
        # domains in first section
        fields = sections[0].split()
        for i in range(1, len(fields)):
            dom = fields[i]
            # add domains if not already added
            if dom not in dom_list:
                dom_list.append(dom)

    fp.close()
    return

#####################################################################
##  MAIN  ###########################################################
#####################################################################


# starting directory
bench_dir = os.getcwd()

# metadata directory (where .names files are)
metadata_dir = "/data1/um/drich/Wheeler-Labs/benchmarks/general-benchmark/db/soeding/metadata/"
metadata_dir = "/home/dr120778/Wheeler-Labs/benchmarks/general-benchmark/db/soeding/metadata"

# jump to metadata folder
os.chdir(metadata_dir)
print("# pwd: {}".format(os.getcwd()))
#print(os.listdir( os.getcwd() ) )

# name and accession filepaths
query_names = "query.names"
query_acc = "query.acc"
target_names = "target.pos.names"
target_acc = "target.pos.acc"
query_s_names = "query.singledomain.names"
query_s_acc = "query.singledomain.acc"

# family/domain lookups
domain_names = "domain.names"
domain_tbl = "domain.tbl"

dom_list = []
dom_name2id = {}
dom_id2name = {}

q_dom = {}
t_dom = {}
qs_dom = {}

# load all domains from queries
print("# add query domains...")
add_acc_to_domains(query_acc, dom_list)

# load all domains from targets
print("# add target domains...")
add_acc_to_domains(target_acc, dom_list)

# load all domains from single domain queries
# print("# add single domain query domains...")
#add_acc_to_domains( query_s_acc, dom_list )

# sort domain list
print("# sort domain list...")
dom_list.sort()

# output all domains to file with associated id
print("# output domain names...")
fp = open(domain_names, "w")
for i in range(len(dom_list)):
    did = i
    dname = dom_list[i]
    dom_name2id[dname] = did
    dom_id2name[did] = dname
    # if dname is formatted as database|uniqueid|name
    if (dname.find(dname) != -1):
        fields = dname.split("|")
        dname = fields[1]
    # output line
    fp.write("{} {}\n".format(did, dname))

fp.close()

print("# ...done.")

os.chdir(bench_dir)
