#!/bin/sh

BASE_DIR=$(cd $(dirname $0);pwd)

cd ${BASE_DIR}
cd source

OUTPUT_DIR=${BASE_DIR}/html

# make output directory
mkdir ${OUTPUT_DIR}
MAIN_CSS=${BASE_DIR}/main.css

# At first, create directory
find ./ -type d | while read dir; do
    mkdir -p ${OUTPUT_DIR}/${dir}
done

find ./ -type f | while read f; do
    base=$(basename ${f})
    dir=$(dirname ${f})
    ext=${base##*.}
    file_without_ext=${base%.*}

    # if it is markdown, use pandoc and generate html.
    if [ ${ext} = "md" ]
    then
        output_file=${OUTPUT_DIR}/${dir}/${file_without_ext}.html
        echo "input:" ${f} "output:" ${output_file}
        pandoc ${f} -H ${MAIN_CSS} -t html5 --mathjax -s \
                    -f markdown+hard_line_breaks --filter ${BASE_DIR}/include_file.hs \
                    --highlight-style tango -s -o ${output_file} 
    else
        output_file=${OUTPUT_DIR}/${dir}/${base}
        echo "cp:" ${f} "output:" ${output_file}
        cp ${f} ${output_file}
    fi
done
