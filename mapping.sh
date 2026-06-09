#!/bin/bash
set -euo pipefail

# ======== config ========
INDEX=index/index
FASTQ_DIR=../SRA_RNA
OUT_DIR=mapping_out
LOG_DIR=${OUT_DIR}/logs

# parallel
JOBS=5
THREADS_PER_JOB=16

mkdir -p ${OUT_DIR} ${LOG_DIR}

# ========================
process_sample() {
    local sample=$1
    local index=$2
    local fq_dir=$3
    local out_dir=$4
    local log_dir=$5
    local threads=$6

    echo "START ${sample}"

    hisat2 -x ${index} \
           -1 ${fq_dir}/${sample}_1.fastq \
           -2 ${fq_dir}/${sample}_2.fastq \
           -p ${threads} \
           --dta \
           --no-unal \
           --summary-file ${log_dir}/${sample}.summary.txt \
           2> ${log_dir}/${sample}.hisat2.log \
      | samtools sort -@ 4 -m 4G \
            -o ${out_dir}/${sample}.sorted.bam -

    samtools index -@ 4 ${out_dir}/${sample}.sorted.bam

    echo "DONE  ${sample}"
}
export -f process_sample

# =======================
ls ${FASTQ_DIR}/*_1.fastq \
  | xargs -n1 basename \
  | sed 's/_1.fastq//' \
  | parallel -j ${JOBS} --bar --joblog ${LOG_DIR}/parallel.log \
        process_sample {} ${INDEX} ${FASTQ_DIR} ${OUT_DIR} ${LOG_DIR} ${THREADS_PER_JOB}

echo "Finished！BAM files: ${OUT_DIR}"
