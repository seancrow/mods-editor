#!/bin/sh
mkdir output
xsltproc -o output/output.txt schema2list.xsl mods-3-4.xsd
grep -v ^# output/output.txt | sort > output/sorted.txt
grep -v @ output/sorted.txt > output/sortedelements.txt

