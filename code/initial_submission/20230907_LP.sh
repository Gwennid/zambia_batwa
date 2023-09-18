infile=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/preparedata_Oct2018/zbatwa6 
cd /crex/proj/snic2020-2-10/uppstore2018150/private/results/LP
module load bioinfo-tools plink
plink --bfile ${infile} --extract 2-136608746.txt --make-bed --recode --out zbatwa6_2-136608746
cat zbatwa6_2-136608746.ped | cut -f7,8 -d" " | sort | uniq -c
# 2 0 0
#76 C C
# 2 G C
# Obs! One of the heterozygous is the fake.

#Same for another mutation
plink --bfile ${infile} --extract 2-136608643.txt --make-bed --recode --out zbatwa6_2-136608643
cat zbatwa6_2-136608643.ped | cut -f7,8 -d" " | sort | uniq -c
#The only heterozygous is the fake.

#
# Same for the agropastoralists
#
infile=/crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/zbantu6
plink --bfile ${infile} --extract 2-136608746.txt --make-bed --recode --out zbantu6_2-136608746
cat zbantu6_2-136608746.ped | cut -f7,8 -d" " | sort | uniq -c
# 44 C C
#  1 G C
# Obs! The heterozygous is the fake.
plink --bfile ${infile} --extract 2-136608643.txt --make-bed --recode --out zbantu6_2-136608643
cat zbantu6_2-136608643.ped | cut -f7,8 -d" " | sort | uniq -c

# Unfortunately the variant is not in the merge of the two Zambian datasets
grep "2-136608746" /crex/proj/snic2020-2-10/uppstore2018150/private/tmp/prepareanalysisset_December2020/zbatwa10_zbantu9_3.bim
