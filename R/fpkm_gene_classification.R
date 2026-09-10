# fpkm_gene_classification.R

library(readr)
library(dplyr)
library(data.table)

# -------------------------------------------------------
# Function: Classify genes based on FPKM into 3 groups
#            and organize outputs by tissue and category.
# -------------------------------------------------------
library(data.table)
library(dplyr)
library(readr)
library(stringr)

classify_genes_by_expression <- function(
    input_file,
    output_dir,
    tissues,
    expression_breaks = c("<1", "1-10", ">10")
) {

  fpkm_data <- fread(input_file)
  all_samples <- colnames(fpkm_data)[-1]  
  

  categories <- c("low1", "1-10", "more10")
  for (cat in categories) {
    for (tissue in tissues) {
      dir.create(file.path(output_dir, cat, tissue), recursive = TRUE, showWarnings = FALSE)
    }
  }
  

  for (sample in all_samples) {

    tissue <- str_split_fixed(sample, "-", 2)[, 1]
    
    if (!tissue %in% tissues) {
      warning(paste("Sample", sample, "tissue", tissue, "not found in tissue list. Skipping."))
      next
    }
    
    sample_data <- fpkm_data %>%
      select(gene, all_of(sample)) %>%
      rename(FPKM = all_of(sample))
    
    low_expr <- sample_data %>% filter(FPKM < 1) %>% select(gene)
    mid_expr <- sample_data %>% filter(FPKM >= 1 & FPKM <= 10) %>% select(gene)
    high_expr <- sample_data %>% filter(FPKM > 10) %>% select(gene)
    
    write_delim(low_expr,  file.path(output_dir, "low1", tissue, paste0(sample, ".txt")), delim = "\t")
    write_delim(mid_expr,  file.path(output_dir, "1-10", tissue, paste0(sample, ".txt")), delim = "\t")
    write_delim(high_expr, file.path(output_dir, "more10", tissue, paste0(sample, ".txt")), delim = "\t")
  }
  
  message("Gene expression classification completed.")
}
