# map_genes_to_snp_positions.R

library(data.table)

# -----------------------------------------------------------
# Function: Map gene lists (from expression categories)
#          to SNP position files for each tissue.
# -----------------------------------------------------------
map_gene_lists_to_positions <- function(
    expression_dir,
    output_dir,
    categories = c("low1", "1-10", "more10"),
    tissues
) {
  dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)
  
  # 创建输出目录结构
  for (cat_name in categories) {
    for (tissue in tissues) {
      dir.create(file.path(output_dir, cat_name, tissue), showWarnings = FALSE, recursive = TRUE)
    }
  }
  
  for (cat_name in categories) {
    for (tissue in tissues) {
      expr_path <- file.path(expression_dir, cat_name, tissue)
      snp_file <- file.path(expression_dir, tissue, paste0(tissue,"_modified.txt"))
      
      if (!dir.exists(expr_path)) {
        message("Expression folder missing: ", expr_path, " — skipping.")
        next
      }
      if (!file.exists(snp_file)) {
        message("SNP position file missing: ", snp_file, " — skipping.")
        next
      }
      
      snp_data <- fread(snp_file, header = FALSE, col.names = c("gene", "position"))
      expr_files <- list.files(expr_path, pattern = "\\.txt$", full.names = TRUE)
      if (length(expr_files) == 0) {
        message("No expression gene files in: ", expr_path, " — skipping.")
        next
      }
      
      for (expr_file in expr_files) {
        gene_list <- fread(expr_file, header = FALSE, col.names = "gene")
        matched <- snp_data[gene %in% gene_list$gene, unique(position)]
        
        sample_name <- tools::file_path_sans_ext(basename(expr_file))
        output_file <- file.path(output_dir, cat_name, tissue, paste0(sample_name, ".txt"))
        fwrite(data.table(matched), file = output_file, sep = "\t", col.names = FALSE, quote = FALSE)
        
        message("Category: ", cat_name, " | Tissue: ", tissue, " | Sample: ", sample_name,
                " → Saved to ", output_file)
      }
    }
  }
  
  message("All gene-to-position mappings completed. Results saved in: ", output_dir)
}

