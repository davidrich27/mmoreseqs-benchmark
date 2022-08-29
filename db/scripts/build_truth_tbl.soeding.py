#!/bin/usr/env python
#####################################################################
#  FILE:  build_truth_domain_tbl.py
#  DESC:  Build table of domains with ids
#####################################################################

import os,sys
import numpy as np

# load names file
def load_names( filename ):
	# dictionaries
	name2id = {}
	id2name = {}
	# open .names file
	fp 	= open(filename, "r")
	for line in fp:
		# parse fields
		fields = line.split()
		myid 	= fields[0]
		myname	= fields[1]
		# add to dicts
		name2id[myname] 	= myid
		id2name[myid] 		= myname
	# close file
	fp.close()	
	return name2id, id2name 

# add domains from accession file to list
def add_acc_to_dom_list( filename, dom_list ):
	# open .acc file
	fp = open( filename, "r")
	for line in fp:
		# section breaks on |
		sections	= line.split("|")
		# domains in first section
		fields  	= sections[0].split()
		for i in range( 1, len(fields) ):
			dom = fields[i]
			# add domains if not already added
			if dom not in dom_list:
				dom_list.append(dom)	

	fp.close()
	return	

# add domains from accession file to dictionary
def add_acc_to_dom_dict( filename, dom_dict, d_name2id, my_name2id ):
	# open .acc file
	fp = open( filename, "r")
	for line in fp:
		# section breaks on |
		sections	= line.split("|")
		# domains in first section
		fields  	= sections[0].split()
		my_name 	= fields[0]
		my_id 		= my_name2id[my_name]
		# for each domain in accession, add to dict
		for i in range( 1, len(fields) ):
			d_name = fields[i]
			d_id = d_name2id[d_name]
			dom_dict[d_id].append(my_id)	

	fp.close()
	return	

# output domain table
def output_domain_tbl( file_out, d_list, q_dom, t_dom ):
	# output file
	fp = open(file_out, "w")
	# header
	fp.write("# domain_id num_query num_target | query_id ... | target_id ...\n")
	# for each domain
	for d_id in d_list:
		fp.write("{} {} {} | ".format( d_id, len(q_dom[d_id]), len(t_dom[d_id]) ))
		# for each query in domain
		for q_id in q_dom[d_id]:
			fp.write("{} ".format(q_id))
		# break
		fp.write("| ")
		# for each target in domain
		for t_id in t_dom[d_id]:
			fp.write("{} ".format(t_id))
		# end line
		fp.write("\n")
	fp.close()
	return

# load domain table
def load_domain_tbl( file_in ):
	dom_tbl = {}
	# input file
	fp = open(file_in, "r")

	for line in fp:
		# ignore comments
		if line.startswith("#"):
			continue
		# parse line
		line = line.strip()
		sections = line.split("|")
		# first section (domain / counts )
		d_sec 	= sections[0]
		fields 	= d_sec.split()

		d_id 	= int(fields[0])
		num_q 	= int(fields[1])
		num_t 	= int(fields[2])
	
		dom_tbl[d_id] = {}
		dom_tbl[d_id]["q"] = []
		dom_tbl[d_id]["t"] = []

		# second section (queries)
		q_sec 	= sections[1]
		fields 	= q_sec.split()
		for q_id in fields:
			dom_tbl[d_id]["q"].append(q_id)

		# third section (targets)
		t_sec 	= sections[2]
		fields 	= t_sec.split() 
		for t_id in fields:
			dom_tbl[d_id]["t"].append(t_id)

	return dom_tbl
 
# output truth table
def output_truth_tbl( file_out, truth_tbl ):
	# output file
	fp = open(file_out, "w")
	# header
	fp.write("# query_id num_targets | target_id ...\n")
	# for each query in truth table
	for q_id in truth_tbl:
		fp.write("{} {} | ".format( q_id, len(truth_tbl[q_id]) ))
		# for each target linked with query
		for t_id in truth_tbl[q_id]:
			fp.write("{} ".format(t_id))
		# end line
		fp.write("\n")
	fp.close()
	return

# load truth table
def load_truth_tbl( file_in ):
	truth_tbl = {}
	# input file
	fp = open(file_in, "r")
	# read file
	for line in fp:
		# ignore comment lines
		if line.startswith("#"):
			continue
		line.strip()
		sections = line.split("|")
		# first section
		q_sec = sections[0].split()
		q_id 	= q_sec[0]
		#num_t 	= q_sec[1]
		truth_tbl[q_id] = []
		# second section
		t_sec = sections[1].split()
		for t_id in t_sec:
			truth_tbl[q_id].append()
		# convert list to set
		truth_tbl[q_id] = set(truth_tbl[q_id])
	fp.close()
	return truth_tbl
	

#####################################################################
##  MAIN  ###########################################################
#####################################################################

# starting directory
bench_dir = os.getcwd()

# metadata directory (where .names files are)
metadata_dir = "/home/dr120778/Wheeler-Labs/benchmarks/general-benchmark/db/soeding/metadata"

# jump to metadata folder
os.chdir(metadata_dir)
print("# pwd: {}".format( os.getcwd() ) )
#print(os.listdir( os.getcwd() ) )

# name and accession filepaths 
q_names 	= "query.names"
q_acc  		= "query.acc" 
t_names 	= "target.pos.names"
t_acc 		= "target.pos.acc"
qs_names 	= "query.singledomain.names"
qs_acc 		= "query.singledomain.acc"

# domain name and table filenames
d_names 	= "domain.names"
d_tbl 		= "domain.tbl"

# truth table filenames
t_tbl 		= "truth.tbl"

print("# OUTPUT: {}".format(d_tbl) )

# output domain table
print("# load domain table...")
dom_tbl = load_domain_tbl( d_tbl )

print("# build truth table from domain table...")
# convert domain table to truth table
# domain table has dict[domain] -> { query_set, target_set }
# truth table has dict[query] -> { target_set }
truth_tbl = {}
for d_id in dom_tbl.keys():
	q_list = dom_tbl[d_id]["q"]
	t_list = dom_tbl[d_id]["t"]
	for q_id in q_list:
		# if query is not already in truth table, add it
		if q_id not in truth_tbl.keys():
			truth_tbl[q_id] = set()
		# if target is not already in query set, add it
		for t_id in t_list:
			truth_tbl[q_id].add(t_id)

print("# output truth table")
output_truth_tbl( t_tbl, truth_tbl )

print("# ...done.")
# back to original directory
os.chdir(bench_dir)
