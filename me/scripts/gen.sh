#!/bin/sh

exec_name="resume-parser-exe"
aux_dir="me/aux"
in_file_name="me/pipeline/tex/resume.tex"
out_dir="me/pipeline/pdf"
out_file_name="me/pipeline/pdf/resume.pdf"

if [ $# -ne 0 ]; then
  arg="$1"
fi

stack build
stack exec $exec_name $arg
latexmk -pdf -auxdir=$aux_dir -outdir=$out_dir $in_file_name
open $out_file_name

