# 20200421
# Gwenna Breton
# Goal: phase the data.

###### USEFUL ################
module load bioinfo-tools SHAPEIT/v2.r904
module load bioinfo-tools plink/1.90b4.9
##############################

# Genetic map (recommended by MV)
/proj/uppstore2017249/DATA/Genetic_Map_Hapmap/genetic_map_GRCh37_chr1.hapmap.txt

# KGP haplotype data in the right format for IMPUTE2 (includes genetic maps - not sure where they come from).
/proj/uppstore2017249/DATA/KGP_reference_haplotypes/

# If I want to phase the X chromosome, I need to download an updated archive from this webpage: https://mathgen.stats.ox.ac.uk/impute/1000GP_Phase3.html.
#For the moment I do not want because we have no specific hypothesis requiring a phased X chromosome (and I have not kept the X chromosome in my preprocessing anyway).

# My input data (plink binary fileset).
/proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex

# Prepare the data.
#See steps in http://www.griv.org/shapeit/pages/documentation.html. I have already performed the relevant ones (i.e. missingness filtering). The only thing left is to split by chromosome.
input=/proj/uppstore2018150/private/tmp/prepareanalysisset_March2020/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex
output=/proj/uppstore2018150/private/tmp/20200421_phasing/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex
for chr in $(seq 1 22) ; do plink --bfile ${input} --chr $chr --make-bed --out ${output}_chr$chr ; done

# Recombination map.
#The maps in /proj/uppstore2017249/DATA/KGP_reference_haplotypes/ are in the right format, but I am not sure which set to use. I will start with genetic_map_GRCh37_chr9.txt set, because it has the same number of lines than the ones MV recommended earlier (see Project2 labbook 2019-09-06 entries and the files in /proj/uppstore2017249/DATA/Genetic_Map_Hapmap/).

# Alignment of the SNPs between the GWAS dataset and the reference panel.
cd /proj/uppstore2018150/private/tmp/20200421_phasing

chr=22
REF_DATASET=/proj/uppstore2017249/DATA/KGP_reference_haplotypes/1000GP_Phase3_chr
BED=/proj/uppstore2018150/private/tmp/20200421_phasing/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr
GENETIC_MAP=/proj/uppstore2017249/DATA/KGP_reference_haplotypes/genetic_map_GRCh37_chr

shapeit -check \
        -B ${BED}${chr} \
        -M ${GENETIC_MAP}${chr}.txt \
        --input-ref ${REF_DATASET}${chr}.hap.gz ${REF_DATASET}${chr}.legend.gz /proj/uppstore2017249/DATA/KGP_reference_haplotypes/1000GP_Phase3.sample \
        --output-log ${BED}${chr}.alignments
#Identify variants with either strand issues, or present only in dataset to be phased (the variants found only in the reference dataset are excluded automatically).
#What should I do here? Lazy option: remove them all. Better option: flip the sites which are not consistent (but I do not have a fake anymore...). Almost 10% of sites would be lost (for chr22) if I do not do that.
cut -f4 ${BED}${chr}.alignments.snp.strand | grep -v "main_A" > ${BED}${chr}.alignments.snp.strand.flip #outputs all the sites which should be flipped or removed.
plink --bfile ${BED}${chr} --flip ${BED}${chr}.alignments.snp.strand.flip --make-bed --out ${BED}${chr}f
#Does not work because at least one position is double > one where there are two variants in the 1000G datasets (multiallelic sites made into several biallelic). Only 3 out of 346 variants. I think I will exclude them from the list.
sort ${BED}${chr}.alignments.snp.strand.flip | uniq > tmp; mv tmp ${BED}${chr}.alignments.snp.strand.flip
plink --bfile ${BED}${chr} --flip ${BED}${chr}.alignments.snp.strand.flip --make-bed --out ${BED}${chr}f

shapeit -check \
        -B ${BED}${chr}f \
        -M ${GENETIC_MAP}${chr}.txt \
        --input-ref ${REF_DATASET}${chr}.hap.gz ${REF_DATASET}${chr}.legend.gz /proj/uppstore2017249/DATA/KGP_reference_haplotypes/1000GP_Phase3.sample \
        --output-log ${BED}${chr}f.alignments
#only 2 snps still have strand issues (two positions with two entries). Why do I have something which looks like indels?? (e.g. CGTT)

shapeit -check \
        -B ${BED}${chr}f \
        -M ${GENETIC_MAP}${chr}.txt \
        --input-ref ${REF_DATASET}${chr}.hap.gz ${REF_DATASET}${chr}.legend.gz /proj/uppstore2017249/DATA/KGP_reference_haplotypes/1000GP_Phase3.sample \
        --exclude-snp ${BED}${chr}f.alignments.snp.strand.exclude

cd /proj/uppstore2018150/private/scripts/bashout/
(echo '#!/bin/bash -l
module load bioinfo-tools SHAPEIT/v2.r904
cd /proj/uppstore2018150/private/tmp/20200421_phasing
chr=22
REF_DATASET=/proj/uppstore2017249/DATA/KGP_reference_haplotypes/1000GP_Phase3_chr
BED=/proj/uppstore2018150/private/tmp/20200421_phasing/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr
GENETIC_MAP=/proj/uppstore2017249/DATA/KGP_reference_haplotypes/genetic_map_GRCh37_chr
shapeit -B ${BED}${chr}f -M ${GENETIC_MAP}${chr}.txt --input-ref ${REF_DATASET}${chr}.hap.gz ${REF_DATASET}${chr}.legend.gz /proj/uppstore2017249/DATA/KGP_reference_haplotypes/1000GP_Phase3.sample --exclude-snp ${BED}${chr}f.alignments.snp.strand.exclude -T 8 -W 0.5 --output-graph ${BED}${chr}f.phased_withKGP.graph --output-log ${BED}${chr}f.phased_withKGP.graph
shapeit -convert --input-graph ${BED}${chr}f.phased_withKGP.graph --output-max ${BED}${chr}f.phased_withKGP --output-log ${BED}${chr}f.phased_withKGP
shapeit -convert --input-haps ${BED}${chr}f.phased_withKGP --output-vcf ${BED}${chr}f.phased_withKGP.vcf
exit 0') | sbatch -p core -n 4 -t 24:0:0 -A snic2019-8-14 -J phasing_chr22 -o phasing_chr22.output -e phasing_chr22.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL

# 20200422 - Phase the rest of the chromosomes.
cd /proj/uppstore2018150/private/tmp/20200421_phasing
chr=21
REF_DATASET=/proj/uppstore2017249/DATA/KGP_reference_haplotypes/1000GP_Phase3_chr
BED=/proj/uppstore2018150/private/tmp/20200421_phasing/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr
GENETIC_MAP=/proj/uppstore2017249/DATA/KGP_reference_haplotypes/genetic_map_GRCh37_chr
shapeit -check \
        -B ${BED}${chr} \
        -M ${GENETIC_MAP}${chr}.txt \
        --input-ref ${REF_DATASET}${chr}.hap.gz ${REF_DATASET}${chr}.legend.gz /proj/uppstore2017249/DATA/KGP_reference_haplotypes/1000GP_Phase3.sample \
        --output-log ${BED}${chr}.alignments
cut -f4 ${BED}${chr}.alignments.snp.strand | grep -v "main_A" | sort | uniq > ${BED}${chr}.alignments.snp.strand.flip
plink --bfile ${BED}${chr} --flip ${BED}${chr}.alignments.snp.strand.flip --make-bed --out ${BED}${chr}f
shapeit -check \
        -B ${BED}${chr}f \
        -M ${GENETIC_MAP}${chr}.txt \
        --input-ref ${REF_DATASET}${chr}.hap.gz ${REF_DATASET}${chr}.legend.gz /proj/uppstore2017249/DATA/KGP_reference_haplotypes/1000GP_Phase3.sample \
        --output-log ${BED}${chr}f.alignments
#The command below is an extra check - run it only if phasing does not start!
#shapeit -check \
#        -B ${BED}${chr}f \
#        -M ${GENETIC_MAP}${chr}.txt \
#        --input-ref ${REF_DATASET}${chr}.hap.gz ${REF_DATASET}${chr}.legend.gz /proj/uppstore2017249/DATA/KGP_reference_haplotypes/1000GP_Phase3.sample \
#        --exclude-snp ${BED}${chr}f.alignments.snp.strand.exclude

cd /proj/uppstore2018150/private/scripts/bashout/
(echo '#!/bin/bash -l'
echo "chr=${chr}"
echo 'module load bioinfo-tools SHAPEIT/v2.r904
cd /proj/uppstore2018150/private/tmp/20200421_phasing
REF_DATASET=/proj/uppstore2017249/DATA/KGP_reference_haplotypes/1000GP_Phase3_chr
BED=/proj/uppstore2018150/private/tmp/20200421_phasing/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr
GENETIC_MAP=/proj/uppstore2017249/DATA/KGP_reference_haplotypes/genetic_map_GRCh37_chr
shapeit -B ${BED}${chr}f -M ${GENETIC_MAP}${chr}.txt --input-ref ${REF_DATASET}${chr}.hap.gz ${REF_DATASET}${chr}.legend.gz /proj/uppstore2017249/DATA/KGP_reference_haplotypes/1000GP_Phase3.sample --exclude-snp ${BED}${chr}f.alignments.snp.strand.exclude -T 2 -W 0.5 --output-graph ${BED}${chr}f.phased_withKGP.graph --output-log ${BED}${chr}f.phased_withKGP.graph
shapeit -convert --input-graph ${BED}${chr}f.phased_withKGP.graph --output-max ${BED}${chr}f.phased_withKGP --output-log ${BED}${chr}f.phased_withKGP
shapeit -convert --input-haps ${BED}${chr}f.phased_withKGP --output-vcf ${BED}${chr}f.phased_withKGP.vcf
exit 0') | sbatch -p core -n 2 -t 24:0:0 -A snic2019-8-14 -J phasing_chr${chr} -o phasing_chr${chr}.output -e phasing_chr${chr}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
