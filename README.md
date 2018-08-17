# HOS-ContentIndexing
A few scripts to insert document contents into SOLR indices built by HOS-MetadataTransformation
* Still alpha and not completely working*

# Requirements
* PHP (version 5.x or higher) must be installed
* bash for executing the scripts

## Installation
* Check out the repository to a convenient location
* Apache Tika is needed as a jar-File. Please copy a version of tika-app-1.17.jar to the opt-directory. If you use another version than tika 1.17, please feel free to modify the shell scripts in bin to allow other versions
* configure your shell environment to hold the credentials for your SOLR-system

## How to use
* currently, only one repository (electronic php-thesises of the SUBHH) is supported.
* The process of extracting the document-id/fulltext path-pairs is not yet included. An example s given in /data/ediss/links_to_documents.tsv. Please create new files for new sources.

## TODOs
* support for multiple fulltext files for a single ID
* automatic extraction of the document-id/fulltext path-pairs
* (...)
