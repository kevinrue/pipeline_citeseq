################################################################################
# Dependencies 
# module load bio/cellranger/3.0.1

SAMPLES = ["pbmc_1k_protein_v3"]

rule all:
    input:
        "cellranger_count/.done"

rule check_path:
    input:
        "Snakefile"
    output:
        "checks/PATH"
    shell:
        r"echo $PATH | sed 's/:/\n/g' > {output}"

rule cellranger_testrun:
    input:
        "Snakefile"
    output:
        directory("checks/cellranger_testrun")
    threads: 4
    resources:
        mem_mb=32 * 1024
    shell:
        """
        cellranger testrun --id=cellranger_testrun &&
        mv cellranger_testrun checks/
        """

rule cellranger_samples:
    input:
        "data/{sample}_library.csv"
    output:
        directory("cellranger_count/{sample}")
    threads: 24
    resources:
        mem_mb=256 * 1024
    shell:
        """
        cellranger count --id={wildcards.sample} \
                   --libraries=data/{wildcards.sample}_library.csv \
                   --transcriptome=/ifs/mirror/10xgenomics/refdata-cellranger-GRCh38-3.0.0 \
                   --feature-ref=data/{wildcards.sample}_feature_ref.csv \
                   --expect-cells=1000 \
                   --jobmode=local \
                   --localcores=24 \
                   --localmem=256 &&
        mv {wildcards.sample} {output}
        """

rule cellranger:
    input:
        expand("cellranger_count/{sample}", sample=SAMPLES)
    output:
        "cellranger_count/.done"
    shell:
        "touch {output}"
