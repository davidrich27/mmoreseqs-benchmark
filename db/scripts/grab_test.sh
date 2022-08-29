hmm=$1
fasta=$2
out=$3

echo ${out}/${hmm}.${fasta}

python3 grab_hmm.py pmark.hmm ${hmm} > ${out}/${hmm}.hmm
python3 grab_fa.py pmark.fa ${hmm}/${fasta} > ${out}/${hmm}.${fasta}.fa 
