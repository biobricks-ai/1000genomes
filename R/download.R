# This file downloads data files for homo sapiens from stringDB
library(rvest)
library(purrr)
library(fs)

options(timeout=1800) # download timeout

outs <- fs::dir_create("cache/") # Create directory to which the downloaded files will be written 
href <- rvest::read_html("https://string-db.org/cgi/download?sessionId=bnTKutRFqrJe&species_text=Homo+sapiens") |> html_elements("a") |> html_attr("href") 
dataref <- keep(href,~ grepl("*.gz$|*.txt$",.)) # URLs of files to be downloaded
dataref <- dataref[!grepl(dataref, pattern="_schema")]
files   <- fs::path_file(dataref) |> partial(fs::path,outs)() # output paths

fs::dir_ls("cache/") |> fs::file_delete() # delete any files already present 
walk2(dataref, files, download.file)

