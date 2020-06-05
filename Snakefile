
rule check_path:
    input:
        "Snakefile"
    output:
        "checks/PATH"
    shell:
        "echo $PATH > {output}"

rule test_cellranger:
    input:
        "Snakefile"
    output:
        "checks/tiny"
    shell:
        """
        cellranger testrun --id=tiny --localcores 4 --localmem=64 &&
        touch {output}
        """
    
# Note that cellranger must already by on the PATH
# i.e., module load bio/cellranger/3.0.1
rule cellranger:
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
