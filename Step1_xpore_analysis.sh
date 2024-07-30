#! /bin/bash
#SBATCH --job-name=xpore
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --time=20-00:00:00

echo Start time is `date +%Y/%m/%d--%H:%M`

source ~/.bashrc
source /opt/app/anaconda3/bin/activate xpore



for tissue in N1 N2 N3 N4 N5 T1 T2 T3 T4 T5;

do
work_dir=/home/colorectalCA/Modification/xPore
sample=${tissue}
fast5_pass=/home/colorectalCA/raw_fast5/fast5_${tissue}
fastq_pass=/home/colorectalCA/fastq_pass/fastq_${tissue}


mkdir ${work_dir}/minimap_out

/opt/app/anaconda3/envs/dena/bin/minimap2 -ax map-ont -uf -t 10 --secondary=no /share2/Reference/hg38/gencode.v35.transcripts.fa ${fastq_pass}/${sample}.fastq > ${work_dir}/minimap_out/${sample}_aln.sam 2>> ${work_dir}/minimap_out/${sample}_aln.sam.log
/share2/Software/Conda_install/bin/samtools view -bS -@ 10 ${work_dir}/minimap_out/${sample}_aln.sam |/share2/Software/Conda_install/bin/samtools sort -@ 20 -o ${work_dir}/minimap_out/${sample}_aln.sort.bam
/share2/Software/Conda_install/bin/samtools index -@ 10 ${work_dir}/minimap_out/${sample}_aln.sort.bam

#nanopolish
/opt/app/anaconda3/envs/nanopolish_2/bin/nanopolish index -d ${fast5_pass} ${fastq_pass}/${sample}.fastq

#mkdir ${work_dir}/Nanopolish

/opt/app/anaconda3/envs/nanopolish_2/bin/nanopolish eventalign --reads ${fastq_pass}/${sample}.fastq --bam ${work_dir}/minimap_out/${sample}_aln.sort.bam --genome /share2/Reference/hg38/gencode.v35.transcripts.fa --summary ${work_dir}/Nanopolish/${sample}_summary.txt --signal-index --scale-events --threads 10 > ${work_dir}/Nanopolish/${sample}_reads-ref.eventalign.txt


#mkdir dir

mkdir -p ${work_dir}/${sample}/xPore/data/Control/dataprep
/opt/app/anaconda3/envs/xpore/bin/xpore dataprep --eventalign ${work_dir}/Nanopolish/${sample}_reads-ref.eventalign.txt --gtf_or_gff /share2/Reference/hg38/gencode.v35.annotation.gtf --n_processes 10 --skip_eventalign_indexing --transcript_fasta /share2/Reference/hg38/gencode.v35.transcripts.fa --out_dir ${work_dir}/${sample}/xPore/data/Control/dataprep 

done

/opt/app/anaconda3/envs/xpore/bin/xpore diffmod --config colonca_config.yml




echo Finish time is `date +%Y/%m/%d--%H:%M`
