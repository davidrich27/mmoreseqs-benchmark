#!/bin/usr/env python
#####################################################################
#  FILE:  build_truth_domain_tbl.py
#  DESC:  Build table of domain matches between queries and
#####################################################################

import os
import sys
import numpy as np


def load_names(filename):
	# dictionaries
	name2id = {}
	id2name = {}
	# load names
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

#####################################################################
##  MAIN  ###########################################################
#####################################################################


metadata_dir = "/data1/um/drich/Wheeler-Labs/benchmarks/profmark-benchmark/db/db_soeding/metadata"

# name and
query_names = "query.names"
query_acc = "query.acc"
target_names = "targetdb.names"
target_acc = "targetdb.acc"

# load query names lookup dicts
q_name2id, q_id2name = load_names(query_names)

# load target names lookup dicts
t_name2id, t_id2name = load_names(target_names)

# family/domain lookups
domain_names = "domain.names"
domain_tbl = "domain.tbl"

dom_list = []
dom_name2id = {}
dom_id2name = {}
q_dom = {}
t_dom = {}

# load all domains from queries
fp = open(query_acc, "r")
for line in fp:
	sections = line.split("|")
	# domains in first section
	fields = sections[0].split()
	for i in range(1, len(fields))):
		dom=fields[i]
		# add domains if not already added
		if dom not in dom_list:
			dom_list.append(dom)

fp.close()

# load all domains from targets
fp=open(target_acc, "r")
for line in fp:
	sections=line.split("|")
	# domains in first section
	fields=sections[0].split()
	for i in range(1, len(fields))):
		dom=fields[i]
		# add domains if not already added
		if dom not in dom_list:
			dom_list.append(dom)

fp.close()


# sort domain list
dom_list.sort()

# output all domains to file with associated id
fp=open(dom_names, "w")
for i in range(len(dom_list)):
	did=i
	dname=dom_list[i]
	dom_name2id[dname]=did
	dom_id2name[did]=dname
	fp.write("{} {}\n".format(did, dname))

fp.close()
