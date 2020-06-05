
# test-snakemake-10x

<!-- badges: start -->
<!-- badges: end -->

The goal of test-snakemake-10x is to write a snakemake pipeline for processing 10x data.

## Input files

Download FASTQ files for '1k PBMCs from a Healthy Donor – Gene Expression and Cell Surface Protein'.

|Input.Files           |Size      |md5sum                           |
|:---------------------|:---------|:--------------------------------|
|FASTQs                |4.34 GB   |2d17f7cf01b64e27d92e4ac03224a4d1 |
|Feature Reference CSV |1 KB      |b39ff23bc0e75a18c955a49d27fc1050 |
|Library CSV           |246 bytes |732fc7ea5328a35acb4b2e06cd5b8250 |

## Prepare a conda environment

```
https://snakemake.readthedocs.io/en/stable/getting_started/installation.html
mamba create -c conda-forge -c bioconda -n snakemake snakemake
conda activate snakemake
mamba install -c conda-forge jupyterlab
mamba install -c anaconda drmaa
```

## Write the pipeline

Various pipelines:

- [Snakemake](Snakefile).
- [CGAT pipeline](pipelines/pipeline_cellranger.py)
