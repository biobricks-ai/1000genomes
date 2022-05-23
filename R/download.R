# This file downloads the vcf files from the 1000 genomes project
library(rvest)
library(purrr)
library(fs)

options(timeout=1800) # download timeout

outs <- fs::dir_create("cache/") # Create directory to which the downloaded files will be written 
href <- rvest::read_html("http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/1000_genomes_project/release/20190312_biallelic_SNV_and_INDEL/") |> html_elements("a") |> html_attr("href") 
dataref <- keep(href,~ grepl("*.txt$|*.tbi$|*.gz$",.)) # URLs of files to be downloaded
dataref <- dataref[!grepl(dataref, pattern="_schema")]
URLs = paste0("http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/1000_genomes_project/release/20190312_biallelic_SNV_and_INDEL/", dataref)
files   <- fs::path_file(dataref) |> partial(fs::path,outs)() # output paths


fs::dir_ls("cache/") |> fs::file_delete() # delete any files already present 
walk2(URLs, files, download.file)
