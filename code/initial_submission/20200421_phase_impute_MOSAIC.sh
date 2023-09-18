# 20200421
# Gwenna Breton
# Goal: phase and impute the data and run analyses which require phased data - in the first stage MOSAIC.

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

######
###### IMPUTATION (not required for MOSAIC though)
######
#TODO 

######
###### TEST MOSAIC
######

#Locally
cd /home/gwennabreton/Programs/MOSAIC

#First, create inputs. The command below creates one file for each population (populations are inferred from the .fam file).
##Phased haplotypes
Rscript convert_from_haps.R /home/gwennabreton/Programs/MOSAIC/DATA/ 22 zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr f.phased_withKGP.haps zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr22f.fam /home/gwennabreton/Programs/MOSAIC/INPUT_test22/
##Pop names
cp DATA/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr22f.fam INPUT_test22/sample.names
##SNP files rs | chr | distance (cM) | position | allele ? | allele ?
##TODO question: do I really need the distance in cM here? Since I am also providing a recombination map? I will try without it.
input=/home/gwennabreton/Programs/MOSAIC/DATA/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr22f.phased_withKGP.haps
cut -f2 -d" " ${input} > col1
cut -f1 -d" " ${input} > col2
cut -f3-5 -d" " ${input} > col4-6
wc -l ${input}
for i in {1..4339}; do echo "0" >> col3; done
paste col1 col2 col3 col4-6 > INPUT_test22/snpfile.22
rm col*
##Recombination map - super weird format: three rows! Row 1: number of sites (format: ":sites:44801"), row 2: positions, row 3: cumulative recombination rate. Preparing the files on Uppmax.
cd /proj/uppstore2018150/private/tmp/20200421_MOSAIC
GENETIC_MAP=/proj/uppstore2017249/DATA/KGP_reference_haplotypes/genetic_map_GRCh37_chr
#chr=22
for chr in {1..21} ; do
grep -v "bp" ${GENETIC_MAP}${chr}.txt > tmp_${chr}
n_var=$(wc -l tmp_${chr} | cut -f1 -d" ")
cut -f1 tmp_${chr} | tr "\n" "\t" | sed 's/[\t]$//' > line2
echo -e "\n" >> line2
cut -f3 tmp_${chr} | tr "\n" "\t" > line3
echo ":sites:${n_var}" > line1
cat line1 line2 line3 > rates.${chr}
rm line1 line2 line3
done
#Then: open the files with nano and remove the empty line.

#Run MOSAIC (locally for the moment).
Rscript mosaic.R Kafue INPUT_test22/ -a 2 -c 22:22 #started at 19:01-19:13, four cores.
Rscript mosaic.R Kafue INPUT_test22/ -a 3 -c 22:22 #I hope this won't overwrite existing outputs!


# -n: number of target individuals. Default is to 1000. If n > actual number of individuals, it takes all of them.

#TODO think about restricting the choice of donor populations.


### 20200422
# Test: prepare snpfiles with real information about genetic distance (using scripts that MV sent me: MOSAIC_prep2.sh and insert-map.pl) (it comes from here: https://github.com/CNSGenomics/impute-pipe/blob/master/exe/insert-map.pl)
#Input: .bim or Eigenstrat/Ancestrymap SNP files
cd /home/gwennabreton/Programs/MOSAIC/INPUT_test22_20200422
cp ../INPUT_test22/snpfile.22 .
perl ~/Documents/PhD/Projects/Project3_Zambia_SNParray/scripts_MV_MOSAIC/insert-map.pl snpfile.22 genetic_map_GRCh37_chr22.txt > snpfile_withgeneticdistance.22 
mv snpfile_withgeneticdistance.22  snpfile.22 

#I copied everything else I needed from INPUT_test22.
Rscript mosaic.R Kafue INPUT_test22_20200422/ -a 3 -c 22:22

# Run MOSAIC with all chromosomes on Uppmax (or at least try!)
cd /proj/uppstore2018150/private/tmp/20200421_MOSAIC/
folder_MOSAIC=/proj/uppstore2018150/private/Programs/MOSAIC/

##Phased haplotypes
#Unfortunately the arg_parser package, which is necessary to run the converting script, is not available for the versions of R available on Uppmax. Thus I will need to transfer the .haps to my local computer and to create the inputs there. Edit: My bad. It is called argparser.
cd /home/gwennabreton/Programs/MOSAIC/
mkdir INPUT_tmp
#replacing by better names in the .fam
for chr in {3..22}; do
cp haps_tmp/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.fam tmp1; bash /home/gwennabreton/Documents/PhD/Projects/Project3_Zambia_SNParray/src/replace_population_names_for_MOSAIC.sh ; mv tmp2 haps_tmp/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.fam ; rm tmp1
done
for chr in {1..22}; do
Rscript convert_from_haps.R /home/gwennabreton/Programs/MOSAIC/haps_tmp/ ${chr} zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr f.phased_withKGP.haps zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.fam /home/gwennabreton/Programs/MOSAIC/INPUT_tmp/
done

##Pop names
# created on my local computer (see details in labbook). I also renamed in the .fam files before creating the haplotypes inputs (see above).

##SNP files. First, create a .bim file from the .haps. Then, replace the genetic distance column.
for chr in {2..22}; do
input_folder=/proj/uppstore2018150/private/tmp/20200421_phasing/
cut -f2 -d" " ${input_folder}zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.phased_withKGP.haps > col1
cut -f1 -d" " ${input_folder}zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.phased_withKGP.haps > col2
cut -f3-5 -d" " ${input_folder}zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.phased_withKGP.haps > col4-6
nrow=$(wc -l ${input_folder}zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.phased_withKGP.haps | cut -f1 -d" ")
for i in $(eval echo "{1..$nrow}") ; do echo "0" >> col3; done
paste col1 col2 col3 col4-6 > tmp${chr}
rm col*
perl insert-map.pl tmp${chr} /proj/uppstore2017249/DATA/KGP_reference_haplotypes/genetic_map_GRCh37_chr${chr}.txt > INPUT/snpfile.${chr}
rm tmp${chr}
done

##Recombination maps: see above.

##Run MOSAIC
mv INPUT INPUT_20200422
# Test run in interactive window (to check that it starts).
Rscript /proj/uppstore2018150/private/Programs/MOSAIC/mosaic.R Kafue_Zambia INPUT_20200422/ -a 3 -c 22:22 -m 1
cd /proj/uppstore2018150/private/tmp/20200421_MOSAIC/
#It does not work... Would have been too easy. It does not find the mosaic package. Great. Why??? I think my computer will work overnight...
#Maybe it is because the packages are downloaded to somewhere temporary? /scratch/13849708/RtmpT5U8eb/downloaded_packages Why would that be the case? MV definitely managed to install it properly.
#So. Everything got installed under x86_64-redhat-linux-gnu-library, but I see that most of my packages (e.g. abc) are under x86_64-pc-linux-gnu-library. Interesting.
#Now it works. Mysterious.


cd /proj/uppstore2018150/private/scripts/bashout/MOSAIC
for pop in Kafue_Zambia Bangweulu_Zambia Bemba_Zambia Lozi_Zambia Tonga_Zambia; do
for i in {3..4} ; do
(echo '#!/bin/bash -l'
echo "
cd /proj/uppstore2018150/private/tmp/20200421_MOSAIC/
Rscript /proj/uppstore2018150/private/Programs/MOSAIC/mosaic.R ${pop} INPUT_20200422/ -a ${i} -c 1:22 -m 8
exit 0") | sbatch -p node -C fat -t 48:0:0 -A snic2019-8-14 -J MOSAIC_${pop}_${i} -o MOSAIC_${pop}_${i}.output -e MOSAIC_${pop}_${i}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
done
done

###
### 20200425
###
### Prepare new MOSAIC inputs with: 1-three samples removed (the San schuster sample and the two Lozi individuals with high non-African admixture); and 2-shorter names (remove country) and correct Mzime to Nzime!!
#
cd /proj/uppstore2018150/private/tmp/20200425_MOSAIC/haps_sample_files
infolder=/proj/uppstore2018150/private/tmp/20200421_phasing
chr=22
haps=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.phased_withKGP.haps
sample=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.phased_withKGP.sample
haps2=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.phased_withKGP.2.haps
sample2=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.phased_withKGP.2.sample

#There are 978 diploid individuals. haps has 5+978*2=1961 columns and sample has 2+978=980 rows.
#I need to remove six columns from haps and three rows from sample. For .sample, I can use grep -v.


#San schuster: row 711 in sample, individual 709. Columns 1422-1423.
#Lozi fifth individual: row 915 in .sample, individual 913 (ZAM27). Columns 1830-1831.
#Lozi 17th individual: row 927 in .sample, individual 925 (ZAM66). Columns 1854-1855.	

cut -d" " -f1-1421,1424-1829,1832-1853,1856-1961 ${infolder}/${haps} > ${haps2}
grep -v schus ${infolder}/${sample} | grep -v ZAM27 | grep -v ZAM66 > ${sample2}

for chr in {1..21}; do
haps=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.phased_withKGP.haps
sample=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.phased_withKGP.sample
haps2=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.phased_withKGP.2.haps
sample2=zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.phased_withKGP.2.sample
cut -d" " -f1-1421,1424-1829,1832-1853,1856-1961 ${infolder}/${haps} > ${haps2}
grep -v schus ${infolder}/${sample} | grep -v ZAM27 | grep -v ZAM66 > ${sample2}
done

#Prepare the .fam with the shorter population names.
grep -v schus ../../20200421_phasing/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr7f.fam | grep -v ZAM27 | grep -v ZAM66 > zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.fam
cp zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.fam tmp1; bash /crex/proj/uppstore2018150/private/scripts/replace_population_names_for_MOSAIC_shorternames.sh ; mv tmp2 zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.fam; rm tmp1

#Comment: this works with R/3.6.1 but not with R/3.6.0 as long as I can understand.
for chr in {1..22}; do
Rscript /proj/uppstore2018150/private/Programs/MOSAIC/convert_from_haps.R /proj/uppstore2018150/private/tmp/20200425_MOSAIC/haps_sample_files/ ${chr} zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr f.phased_withKGP.2.haps zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex.fam /proj/uppstore2018150/private/tmp/20200425_MOSAIC/INPUT/
done
#20200727: I deleted the content of this folder (many files -> not good for Uppmax!). But I can recreate it if needed.

#Prepare the other inputs. I think that I can simply copy the inputs from the previous run as I have not changed anything to the number of variants.
# TODO comment: I had not noticed but the snpfiles I created look super crappy! Example of one row: "1" NA 10 NA 135656 NA NA. So I will create new snpfiles using my initial scripts. This would tend to suggest that the snpfiles are not that important in the end...
cd /proj/uppstore2018150/private/tmp/20200425_MOSAIC/INPUT/
for chr in {1..22}; do
input=../haps_sample_files/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.phased_withKGP.2.haps
cut -f2 -d" " ${input} > col1
cut -f1 -d" " ${input} > col2
cut -f3-5 -d" " ${input} > col4-6
nrow=$(wc -l ../haps_sample_files/zbatwa9_zbantu9_Schlebusch2012_1KGP173_Gurdasani242_Haber71_Patin207_Scheinfeldt52_4fex_chr${chr}f.phased_withKGP.2.haps | cut -f1 -d" ")
for i in $(eval echo "{1..$nrow}") ; do echo "0" >> col3; done
paste col1 col2 col3 col4-6 > snpfile.${chr}
rm col*
cp /proj/uppstore2018150/private/tmp/20200421_MOSAIC/INPUT_20200422/rates.${chr} .
done

#Test Lozi three-way admixture with chromosome 18-22. If I have not removed the right individuals they should show up.
cd /proj/uppstore2018150/private/scripts/bashout/MOSAIC
for pop in Lozi; do
i=3
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools R/3.6.1
cd /proj/uppstore2018150/private/tmp/20200425_MOSAIC/
Rscript /proj/uppstore2018150/private/Programs/MOSAIC/mosaic.R ${pop} INPUT/ -a ${i} -c 18:22
exit 0") | sbatch -p node -C fat -t 12:0:0 -A g2019029 -J MOSAIC_${pop}_${i} -o MOSAIC_${pop}_${i}.output -e MOSAIC_${pop}_${i}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
done
#submitted!
#Seems to work fine, no CEU/non African like component! Great. Now submitting two way admixture for the five Zambian populations for 1-22.

cd /proj/uppstore2018150/private/scripts/bashout/MOSAIC
for pop in Kafue Bangweulu Lozi; do
i=2
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools R/3.6.1
cd /proj/uppstore2018150/private/tmp/20200425_MOSAIC/
Rscript /proj/uppstore2018150/private/Programs/MOSAIC/mosaic.R ${pop} INPUT/ -a ${i} -c 1:22 -m 20
exit 0") | sbatch -p node -C fat -t 24:0:0 -A g2019029 -J MOSAIC_${pop}_${i} -o MOSAIC_${pop}_${i}.output -e MOSAIC_${pop}_${i}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
done
#It took: 11.25 hours on fat node (20 cores) for Bangweulu; 10 h for Kafue; 6.7 hours for Lozi; 3.2 h for Bemba; 3 hours for Tonga.

###
### 20200429: Test replotting the first MOSAIC results (3 and 4 ways admixture)
###
# I will try it out locally.
# cf 20200429_replot_MOSAIC_results.R

###
### 20200430: MOSAIC with a subset of reference populations.
###
# Subset: Yoruba, Baka_Cameroon (least admixture with Bantu-speakers based on ADMIXTURE results) (if need be I could restrict to the individuals with little or no Bantu-speaker component), and Juhoansi. I could also test 4-way and add an east African population, e.g. the Amhara.

cd /proj/uppstore2018150/private/scripts/bashout/MOSAIC

#3-way
for pop in Bangweulu Kafue; do
i=3
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools R/3.6.1
cd /proj/uppstore2018150/private/tmp/20200425_MOSAIC/
Rscript /proj/uppstore2018150/private/Programs/MOSAIC/mosaic.R ${pop} INPUT/ -a ${i} -c 1:22 -p \"Yoruba Baka Juhoansi\" -m 8
exit 0") | sbatch -p core -n 8 -t 24:0:0 -A g2019029 -J MOSAIC_${pop}_${i}_subset -o MOSAIC_${pop}_${i}_subset.output -e MOSAIC_${pop}_${i}_subset.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
done
#Took 5 hours on 8 cores for the Bangweulu, and 2.2 hours on 8 cores for the Kafue.

#4-way
for pop in Bangweulu Kafue; do
i=4
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools R/3.6.1
cd /proj/uppstore2018150/private/tmp/20200425_MOSAIC/
Rscript /proj/uppstore2018150/private/Programs/MOSAIC/mosaic.R ${pop} INPUT/ -a ${i} -c 1:22 -p \"Yoruba Baka Juhoansi Amhara\" -m 8
exit 0") | sbatch -p core -n 8 -t 24:0:0 -A g2019029 -J MOSAIC_${pop}_${i}_subset -o MOSAIC_${pop}_${i}_subset.output -e MOSAIC_${pop}_${i}_subset.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL
done
#Took 9.8 hours on 8 cores for the Bangweulu, and 8.5 hours on 8 cores for the Kafue.



#Oups. I merged the two Baka populations during my file conversion... They do look very similar on the ADMIXTURE plots but that is not optimal.
#TODO later (when I rerun MOSAIC to have everything perfect): split them.

















