

This README provides an overview of the two primary scripts used for RNA-seq processing and genome annotation: the **HISAT2 Mapping Pipeline** and the **BRAKER4 Annotation Pipeline**.

---

# Bioinformatics Pipeline: Mapping & Annotation

This repository contains scripts to automate the alignment of RNA-seq reads and the subsequent structural genome annotation.

## 1. RNA-Seq Read Mapping (`mapping.sh`)
This script performs batch alignment of paired-end FASTQ files to a reference genome using **HISAT2**, followed by sorting and indexing with **Samtools**.

### Features
*   **Parallel Processing:** Uses GNU Parallel to process multiple samples simultaneously.
*   **Efficient Sorting:** Pipes HISAT2 output directly into `samtools sort` to save disk space and I/O time.
*   **Logging:** Generates alignment summaries and job logs for every sample.

### Configuration
Edit the following variables in the script:
*   `INDEX`: Path to the HISAT2 genome index.
*   `FASTQ_DIR`: Directory containing your `*_1.fastq` and `*_2.fastq` files.
*   `JOBS`: Number of samples to process in parallel.
*   `THREADS_PER_JOB`: CPU threads allocated to each HISAT2 instance.

### Usage
```bash
chmod +x mapping.sh
./mapping.sh
```

---

## 2. BRAKER4 Annotation Pipeline (`braker_run.sh`)
This script executes the **BRAKER4** pipeline using **Snakemake** and **Singularity**. It is designed for automated eukaryotic gene prediction.

### Features
*   **Containerized:** Uses Singularity to ensure all dependencies (Augustus, GeneMark, etc.) are handled within a controlled environment.
*   **Reproducible:** Managed by Snakemake for checkpointing and re-entrancy.
*   **Custom Bindings:** Automatically binds `/mnt/data` and temporary directories to the container.

### Configuration
*   **Environment:** Ensure `config.ini` is present in your run directory.
*   **Cores:** Defaults to 32 cores but can be overridden: `CORES=64 ./braker_run.sh`.
*   **Paths:** Update `PIPELINE_DIR` to point to your BRAKER4 installation.

### Usage
```bash
chmod +x braker_run.sh
./braker_run.sh
```

---

## Prerequisites
The following tools must be installed and available in your `$PATH`:

| Tool | Purpose |
| :--- | :--- |
| **HISAT2** | Splice-aware read alignment |
| **Samtools** | BAM file processing and indexing |
| **GNU Parallel** | Multi-sample job scheduling |
| **Snakemake** | Workflow management |
| **Singularity** | Container execution |

## Directory Structure
*   `index/`: Should contain the HISAT2 genome index.
*   `mapping_out/`: Output directory for sorted BAM files.
*   `mapping_out/logs/`: Alignment summaries and error logs.
*   `.singularity_cache/`: Stores downloaded/built Singularity images.
