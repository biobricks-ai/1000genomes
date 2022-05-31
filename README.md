<a href="https://github.com/biobricks-ai/1000_Genomes/actions"><img src="https://github.com/biobricks-ai/1000_Genomes/actions/workflows/bricktools-check.yaml/badge.svg?branch=main"/></a>
# 1000_Genomes
>The 1000 Genomes Project created a catalogue of common human genetic variation, using openly consented samples from people who declared themselves to be healthy.

Biobricks.ai transforms 1000 Genomes into parquet files. 

# Data overview 
- This directory contains data obtained from the 1000 Genomes project.
- The vcf.gz files downloaded from the 1000 Genomes project are located in cache/. The vcf.gz files for each chromosome have been split into smaller files that have been transformed into parquets. Each of these files are saved in a subdirectory that corresponds to the name of the original vcf.gz file.
- Descriptions for each column of the files is shown below.
- The data was downloaded from: http://sideeffects.embl.de/download/

# Description of Files 

Each file contains the following columns.
- CHROM. The chromosome that the genetic variant occurs at.
- POS. The chromosomal position that the genetic variant occurs at.
- ID. The dbSNP ID of the variant if available.
- REF. The reference allele.
- ALT. The alternate allele.
- QUAL. Phred-scaled quality score.
- FILTER. Whether or not the variant has passed all quality filters.
- INFO. The information field for the vcf file (see https://samtools.github.io/hts-specs/VCFv4.1.pdf for more details)
- FORMAT. The genotype format field of the vcf file (see https://samtools.github.io/hts-specs/VCFv4.1.pdf for more details)
- Additional columns with genotype for each individual. Each of the subsequent columns is named with the ID for an individual in the study. Each of the fields in the column contains the genotype of that individual for the genetic variant.

# Usage
```{R}
biobricks::install_brick("1000_Genomes")
biobricks::brick_pull("1000_Genomes)
biobricks::brick_load("1000_Genomes)
```
