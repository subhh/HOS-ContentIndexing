#!/bin/bash
# https://github.com/subhh/HOS-ContentIndexing

# required credentials - PLEASE SPECIFY

# $solr_credentials for curl, e.g. -u myusername:mypassword
# $solr_url, e.g. https://solr.mydomain.info/solr/CORENAME/


# change directory to location of shell script
cd $(dirname $0)

# pathnames
bin_dir="$(readlink -f ../bin)"
opt_dir="$(readlink -f ../opt)"
metadata_dir="$(readlink -f ../data/ediss)"

pdf_dir="$(readlink -f ../data/ediss/pdf)"
fulltext_dir="$(readlink -f ../data/ediss/fulltext)"
upload_dir="$(readlink -f ../data/ediss/upload)"

#log_dir="$(readlink -f ../log)"

#  executables
tica_jar="$opt_dir/tika-app-1.18.jar"
create_json="$bin_dir/create_json.php"

# filenames
targets_file="$metadata_dir/links_to_documents.tsv"


# check for executables
# todo: check for php
# todo: check for java

if [ ! -f "$tica_jar" ]; then
    >&2 echo "tica not found!"
    exit 1
fi

# check for environment
if [ ! -d "$pdf_dir" ]; then
    mkdir -p "$pdf_dir" 
fi

if [ ! -d "$fulltext_dir" ]; then
    mkdir -p "$fulltext_dir" 
fi

if [ ! -d "$upload_dir" ]; then
    mkdir -p "$upload_dir" 
fi

# start metha TODO

# start Openrefine TODO

# fetch missing documents based on tsv

if [ ! -f "$targets_file" ]; then
    >&2 echo "$targets_file not found!"
    exit 1
fi

{
  read
  IFS_OLD=$IFS
  IFS='{	}'
  while read first second; do
    echo $first
    echo $second
    if [ ! -f "$fulltext_dir/$first" ]; then
        curl -s "$second" > $pdf_dir/$first.pdf
    fi 
  done 
} < "$targets_file" 
IFS=$IFS_OLD

# now batch process apache tika
java -jar "$tica_jar" --text --inputDir "$pdf_dir" --outputDir "$fulltext_dir" 

# remove file suffixes
rename s/\.pdf\.txt//i $fulltext_dir/*

# create atomic update scripts TODO
for i in $fulltext_dir/*
do
	php $create_json $i "${i}_esc";
done

mv $fulltext_dir/*_esc $upload_dir
rename s/_esc\//i $upload_dir/*

# curl them to the index TODO
for i in $upload_dir/*
do
	curl $solr_credentials -sS "${solr_url}/update?commit=true" --data-binary @- -H 'Content-type:application/json; charset=utf-8' < $i
done

# clean the pdf documents
rm $pdf_dir/*

# clean the atomic update scripts
rm $upload_dir/*
