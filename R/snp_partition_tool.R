# snp_partition_tool.R

library(data.table)

# ---------------------------------------------
# Function to replace reference chromosome names with numeric labels
# ---------------------------------------------
replace_chromosomes_in_files <- function(tissues, input_prefix, output_prefix) {
  ref_ids <- paste0("NC_0525", 32:72, ".1")
  chrom_ids <- as.character(1:41)
  ref_ids <- c(ref_ids, "NC_053523.1")
  chrom_ids <- c(chrom_ids, "42")
  
  if (!dir.exists(output_prefix)) {
    dir.create(output_prefix, recursive = TRUE)
  }
  
  for (tissue in tissues) {
    input_file <- file.path(input_prefix, paste0(tissue, ".variant_function"))
    output_file <- file.path(output_prefix, paste0(tissue, ".variant_function"))
    
    if (!file.exists(input_file)) {
      message("Input file not found, skipping: ", input_file)
      next
    }
    
    data <- fread(input_file, header = FALSE, sep = "\t")

    for (i in seq_along(ref_ids)) {
      data$V3 <- gsub(ref_ids[i], chrom_ids[i], data$V3)
    }
    
    fwrite(data, file = output_file, sep = "\t", col.names = FALSE, quote = FALSE)
    
    message("Processed ", tissue, ", output saved to ", output_file)
  }
  
  message("All done!")
}

# ---------------------------------------------
# Main function: filter SNPs by functional annotation and rename chromosomes
# ---------------------------------------------
partition_snps_by_annotation <- function(
    tissues,
    category_list,
    input_prefix,
    output_prefix
) {
  for (tissue in tissues) {
    input_file <- file.path(input_prefix, paste0(tissue, ".variant_function"))
    output_dir <- file.path(output_prefix, tissue)
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    
    if (!file.exists(input_file)) {
      message("File not found: ", input_file, " — skipping.")
      next
    }
    
    variant_function <- fread(input_file, fill = TRUE, sep = "\t", header = FALSE)
    
    for (cat_code in names(category_list)) {
      keywords <- category_list[[cat_code]]
      matched_data <- variant_function[V1 %in% keywords, ]
      
      if (nrow(matched_data) == 0) {
        message("Tissue: ", tissue, " | Category: ", " — no matched entries.")
        next
      }
      
      selected_data <- matched_data[, .(V1 = V3, V2 = V4, V3 = V2)]
      selected_data[, V4 := paste(V1, V2, sep = "_")]
      selected_data <- selected_data[, .(V1 = V3, V2 = V4)]
      output_file <- file.path(output_dir, paste0(tissue, "_modified.txt"))
      fwrite(selected_data, file = output_file, sep = "\t", col.names = FALSE, quote = FALSE)
      message("Tissue: ", tissue, " | Category: ", " — output saved to ", output_file)
    }
  }
  message("Processing completed for all tissues.")
}