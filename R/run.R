


# -------------------------------------------------------
#                        STEP 1
#            SNP Partition by Annotation Type
#               Source: snp_partition_tool.R
# -------------------------------------------------------

source("snp_partition_tool.R")  # Load SNP partitioning functions

# Define the tissues to process
tissues <- c("example1", "example2")

# Replace chromosome names in raw variant annotation files
replace_chromosomes_in_files(
  tissues = tissues, 
  input_prefix = "SNPExprClassifier/",         # Path to original variant_function files
  output_prefix = "SNPExprClassifier/output"   # Path to save renamed output
)

# Define functional categories (adjust as needed)
categories <- list(
  "A" = c("upstream", "downstream", "upstream;downstream")
  # Add more categories if needed
)

# Partition SNPs based on functional annotation
partition_snps_by_annotation(
  tissues = tissues,
  category_list = categories,
  input_prefix = "SNPExprClassifier/output",   # Path to renamed annotation files
  output_prefix = "SNPExprClassifier/output"   # Output folder for categorized SNPs
)



# -------------------------------------------------------
#                        STEP 2
#             Classify Genes by Expression Level
#               Source: fpkm_gene_classification.R
# -------------------------------------------------------

source("fpkm_gene_classification.R")  # Load gene expression classification function

# Classify genes into expression bins (e.g., low, mid, high)
classify_genes_by_expression(
  tissues = tissues,
  input_file = "SNPExprClassifier/FPKM.txt",     # Path to input FPKM matrix
  output_dir = "SNPExprClassifier/output"        # Output folder for classified gene lists
)



# -------------------------------------------------------
#                        STEP 3
#             Map Gene Categories to SNP Positions
#              Source: map_genes_to_snp_positions.R
# -------------------------------------------------------

source("map_genes_to_snp_positions.R")  # Load gene-to-SNP mapping function

# Map categorized gene lists to their SNP positions
map_gene_lists_to_positions(
  expression_dir = "SNPExprClassifier/output",             # Folder containing gene list files
  output_dir = "SNPExprClassifier/output/position",        # Folder to save mapped positions
  tissues = tissues
)
