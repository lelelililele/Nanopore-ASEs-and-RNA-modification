# Nanopore RNA modifications and alternative splicing
The script was used to obtain regulation pairs between differential RNA modifications and aberrant alternative splicing events.
## Step1: Obtain differential RNA modifications

[xPore (v2.0)](https://github.com/GoekeLab/xpore), including dataprep, diffmod, and postprocessing modules, was then utilized to identify and analyze differential RNA modification sites in paired tumor and normal tissue samples from five CRC patients.
> Step1_xpore_analysis.sh and Step1_colonca_config.yml
**************************************************************************************
## Step2: Obtain aberrant alternative splicing events
In this process, [SUPPA2](https://github.com/comprna/SUPPA) was used.

> suppa.py generateEvents -i gencode.v35.annotation.gtf -o gencodev35_event  -e SE SS MX RI FL -f ioe  
>
> mer_events='/data/SUPPA/merged.all.events.ioe'  
>
> awk 'FNR==1 && NR!=1 { while (/^\<header>/) getline; } 1 {print}' ./*.ioe > genecodev35_merged.all.events.ioe  
>
> suppa.py psiPerEvent --ioe-file genecodev35_merged.all.events.ioe --expression-file Nanocount_IDtpm5sample -o ./  
>
> suppa.py generateEvents -i gencode.v35.annotation.gtf -o gencodev35_event_transcript -f ioi  
>
> suppa.py diffSplice --method empirical --input genecodev35_merged.all.events.ioe --psi Nanocount_IDtpm5sample_T.psi Nanocount_IDtpm5sample_N.psi --tpm Nanocount_IDtpm5sample_T Nanocount_IDtpm5sample_N --area 1000 --lower-bound 0.05 -gc -o Suppa2_diffSplice  
>
**************************************************************************************
## Step3: Convert modification rate matrix into integer matrix
According to the percentile rank of modification rate, convert matrix into integer matrix.  

> awk 'BEGIN{FS=OFS="\t"}{max = 0}{for(i = 1; i <= 10; i++) if($i > max) max = $i;print $0,$11=max}' diffmod_data > diffmod_data1  
> 
> awk 'BEGIN{FS=OFS="\t"}{min = 999999999}{for(i = 1; i <= 10; i++) if($i < min) min = $i; print $0,$12=min,$13=($11-$12)/3+$12,$14=($11-$12)*2/3+$12}' diffmod_data1 > diffmod_data2  
> 
> awk 'BEGIN{FS=OFS="\t"}{for(i = 1; i <= 10; i++) if($i < $13) $(i+14)=0; else if ($i > $14) $(i+14)=2;  else $(i+14)=1}{print $0}'  diffmod_data2 > diffmod_data3  
>
**************************************************************************************
## Step4: Convert modification rate matrix into integer matrix
By [MatrixEQTL](https://github.com/andreyshabalin/MatrixEQTL), integrated RNA modifications with alternative splicing events to explore relationship pairs.

> Step4_relation_pairs.R

