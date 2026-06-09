#!/bin/bash
set -euo pipefail

PIPELINE_DIR=/mnt/data/bear/jerry/software/BRAKER4
RUN_DIR=./

CORES=${CORES:-32} 
export BRAKER4_CONFIG="$RUN_DIR/config.ini"
export SINGULARITYENV_PREPEND_PATH=/opt/conda/bin

cd "$RUN_DIR"

snakemake \
      --snakefile "$PIPELINE_DIR/Snakefile" \
      --cores "$CORES" --jobs "$CORES" \
      --printshellcmds \
      --rerun-incomplete \
      --latency-wait 120 \
      --restart-times 3 \
      --nolock \
      --use-singularity \
      --singularity-prefix "$PIPELINE_DIR/.singularity_cache" \
      --singularity-args "-B /mnt/data -B /mnt/data/bear/jerry/container_tmp:/tmp --env PREPEND_PATH=/opt/conda/bin"
