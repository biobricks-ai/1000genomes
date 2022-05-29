library(purrr)
library(vroom)
library(arrow)
library(R.utils)
library(tools)

outdir <- fs::dir_create("data")

# Get headers from text files (header found on line 1)
get_headers <- function(file) {
	header = vroom::vroom_lines(file, n_max=1000) 
  header= header[grepl(header, pattern="#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT")] |> strsplit(split='\t') |>
          unlist() 
  return(header)
}

save_the_parquet <- function(f, header, out_dir) {
  out = paste0(out_dir, basename(f), ".parquet")
  vroom::vroom(f, col_names = header, delim='\t') |> write_parquet(sink=out)
  file.remove(f)
  return(1)
}

save_parquet <- function(file) {
  # Create output directory
  gunzip <- fs::dir_create("gunzip")
  out_dir=paste0("data/", file_path_sans_ext(basename(file)), "/")
  dir.create(out_dir)
  # decompress gz file and split into smaller files
  gunzip_file= paste0("gunzip/", file_path_sans_ext(basename(file)))
  command = sprintf('zcat %s | grep -v "#" | split - -l 100000 %s', file, gunzip_file)
  system(command)
  # Convert to parquet 
  header = get_headers(file)
  files = paste0("gunzip/", list.files("gunzip/"))
  res <- lapply(files, FUN=save_the_parquet, header=header, out_dir=out_dir)
  unlink("gunzip", recursive = TRUE)
  return(1)
}

# WRITE OUTS ================================================================================
fs::dir_ls(outdir) |> fs::file_delete() # delete files present in the directory
# fs::dir_ls("cache/", regexp=".vcf.gz") |> walk(save_parquet) # Create parquet files
fs::dir_ls("cache/", regexp=".vcf.gz")[1] |> walk(save_parquet) 




