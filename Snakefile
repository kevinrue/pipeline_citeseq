################################################################################
# Dependencies 
# module load bio/cellranger/3.0.1

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
        "checks/cellranger_testrun"
    shell:
        """
        cellranger testrun --id=cellranger_testrun &&
        mv cellranger_testrun checks
        """

rule cellranger_samples:
    input:
        "data/{sample}_fastqs"
    output:
        "cellranger_count/{sample}"
    shell:
        """
        cellranger count --id={sample} \
                   --libraries={sample}_library.csv \
                   --transcriptome=/ifs/mirror/10xgenomics/refdata-cellranger-GRCh38-3.0.0 \
                   --feature-ref={sample}_feature_ref.csv \
                   --expect-cells=1000
                   --jobmode sge
                   --mempercore=256
        """
