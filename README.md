# Nanopore-ASEs-and-RNA-modification
The script was used to obtain regulation pairs between differential RNA modifications and aberrant alternative splicing events.
## Step1: Obtain differential RNA modifications

[xPore (v2.0)](https://github.com/GoekeLab/xpore), including dataprep, diffmod, and postprocessing modules, was then utilized to identify and analyze differential RNA modification sites in paired tumor and normal tissue samples from five CRC patients.
> Step1_xpore_analysis.sh and Step1_colonca_config.yml
**************************************************************************************
## Step2: Obtain aberrant alternative splicing events
In this process, [SUPPA2](https://github.com/comprna/SUPPA) was used.

> suppa.py generateEvents -i /share2/Reference/hg38/gencode.v35.annotation.gtf -o gencodev35_event  -e SE SS MX RI FL -f ioe  
>
> mer_events='/data/SUPPA/merged.all.events.ioe'  
>
> awk 'FNR==1 && NR!=1 { while (/^\<header>/) getline; } 1 {print}' ./*.ioe > genecodev35_merged.all.events.ioe  
>
> suppa.py psiPerEvent --ioe-file genecodev35_merged.all.events.ioe --expression-file Nanocount_IDtpm5sample -o ./  
>
> suppa.py generateEvents -i /share2/Reference/hg38/gencode.v35.annotation.gtf -o /home/zhanglili/Tasks/Colorectalca/RNA_expression/SUPPA2/gencodev35_event_transcript -f ioi  
>
> suppa.py diffSplice --method empirical --input genecodev35_merged.all.events.ioe --psi Nanocount_IDtpm5sample_T.psi Nanocount_IDtpm5sample_N.psi --tpm Nanocount_IDtpm5sample_T Nanocount_IDtpm5sample_N --area 1000 --lower-bound 0.05 -gc -o Suppa2_diffSplice  
>
