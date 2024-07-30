~/.conda/envs/TAGET/bin/R

#file:/share2/MatrixEQTL/data

library("MatrixEQTL")

base.dir = find.package("MatrixEQTL")

# Then we set the parameters such as selected linear model and
# names of genotype and expression data files.

useModel = modelLINEAR # modelANOVA or modelLINEAR or modelLINEAR_CROSS
SNP_file_name = paste0(base.dir, "/data/diffmod_datam6Ainput_5")
expression_file_name = paste0(base.dir, "/data/Nanocount_AlternativeSplicetpm_5")


covariates_file_name = paste0(base.dir, "/data/Covariatesm6A.txt")


pvOutputThreshold = 1e-2


errorCovariance = numeric()


snps = SlicedData$new()
snps$fileDelimiter = "\t"      # the TAB character
snps$fileOmitCharacters = "NA" # denote missing values
snps$fileSkipRows = 1          # one row of column labels
snps$fileSkipColumns = 1       # one column of row labels
snps$fileSliceSize = 5000      # read file in pieces of 2,000 rows
snps$LoadFile( SNP_file_name )

gene = SlicedData$new()
gene$fileDelimiter = "\t"      # the TAB character
gene$fileOmitCharacters = "NA" # denote missing values
gene$fileSkipRows = 1          # one row of column labels
gene$fileSkipColumns = 1       # one column of row labels
gene$fileSliceSize = 2000      # read file in pieces of 2,000 rows
gene$LoadFile( expression_file_name )

cvrt = SlicedData$new()
cvrt$fileDelimiter = "\t"      # the TAB character
cvrt$fileOmitCharacters = "NA" # denote missing values
cvrt$fileSkipRows = 1          # one row of column labels
cvrt$fileSkipColumns = 1       # one column of row labels
cvrt$fileSliceSize = 2000      # read file in pieces of 2,000 rows
cvrt$LoadFile( covariates_file_name )

# Finally, the main Matrix eQTL function is called:

me = Matrix_eQTL_engine(
    snps = snps,
    gene = gene,
    cvrt = cvrt,
    output_file_name = 'm6A_AS_5_matrixEQTL',
    pvOutputThreshold = pvOutputThreshold,
    useModel = useModel,
    errorCovariance = errorCovariance,
    verbose = TRUE,
    pvalue.hist = TRUE,
    min.pv.by.genesnp = FALSE,
    noFDRsaveMemory = FALSE)

