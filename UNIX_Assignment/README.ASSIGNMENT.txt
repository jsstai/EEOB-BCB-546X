# WORK DONE:
# Step 1: Wrote script convert.sh
# Step 2: Debugged
# Step 3: Ran script as so:

sh convert.sh fang_et_al_genotypes.txt snp_position.txt unknown,multiple ZMMIL,ZMMLR,ZMMMR,,ZMPBA,ZMPIL,ZMPJA

# SCRIPT FEATURES:
# - Works automatically for any number of chromosomes.
# - Can flexibly specify any number of genotypes groups.
# --- Genotype groups specified with single-commas separating members of genotype group
# --- and double-commas separating genotype groups
# - Can flexibly exclude any number of chromosomal identifiers, separated by single-commas.
# --- This could allow classification, for example, by reason why the SNP can be found at
# --- multiple chromosomes; the various types of transposons, viral elements, homology...
