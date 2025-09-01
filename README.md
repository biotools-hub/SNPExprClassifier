
# SNPExprClassifier

**SNPExprClassifier** is an R package for classifying genes based on expression levels across multiple tissues and extracting their SNP positions accordingly. This tool is designed to facilitate SNP annotation partitioning for further integrative genomic analyses.

---

## Features

- Classify genes into expression level bins (e.g., low, moderate, high).
- Support gene expression data from multiple tissues or samples.
- Extract genomic positions of genes from annotated mapping files.
- Output position files for downstream SNP annotation or enrichment analysis.
- Built-in command-line interface for batch processing.

---

## Installation

```r
# Install from local package tarball (recommended for now)
remotes::install_local("SNPExprClassifier", force = TRUE)

# Or if hosted on GitHub:
# remotes::install_github("yourusername/SNPExprClassifier")
```

---

## Directory Structure

Input:
```
/your/project/
├── FPKM.txt
├── tissue1/
│   └── tissue1_modified.txt
├── tissue2/
│   └── tissue2_modified.txt
...
```

Output (after classification and extraction):
```
/output/
├── low1/
│   └── tissue1/
│       └── sample1.txt
...
```

---

## Usage

### R Functions

```r
library(SNPExprClassifier)

# Step 1: Classify snp into functional categories
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

# Step 2: Classify genes into expression categories
classify_genes_by_expression(
  tissues = tissues,
  input_file = "SNPExprClassifier/FPKM.txt",     # Path to input FPKM matrix
  output_dir = "SNPExprClassifier/output"        # Output folder for classified gene lists
)

# Step 3: Extract gene positions by category and tissue
map_gene_lists_to_positions(
  expression_dir = "SNPExprClassifier/output",             # Folder containing gene list files
  output_dir = "SNPExprClassifier/output/position",        # Folder to save mapped positions
  tissues = tissues
)
```

---

## Requirements

- R >= 4.0
- Packages: `data.table`, `remotes`

---

## Author

- **Name**: Chaoliang Wen  
- **Affiliation**: China Agricultural University  
- **Email**: clwen@cau.edu.cn

---
