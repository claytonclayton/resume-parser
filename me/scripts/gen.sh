#!/bin/sh

exec_name="gen"
pdf_path="me/pipeline/pdf/resume.pdf"
aux="me/aux"

if [ $# -ne 0 ]; then
  arg="$1"
fi

mkdir -p $aux
stack build
stack exec $exec_name $arg
open $pdf_path

