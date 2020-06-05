from ruffus import *
import cgatcore.experiment as E
from cgatcore import pipeline as P
import cgatcore.iotools as iotools


import os
import sys


# load options from the config file
PARAMS = P.get_parameters(
 ["%s/pipeline.yml" % os.path.splitext(__file__)[0],
  "../pipeline.yml",
  "pipeline.yml"])


@follows(mkdir("cellranger_count"))
@transform(r"data/pbmc_1k_protein_v3_fastqs", regex(r"^data/(.+)_fastqs"), r"cellranger_count/\1.done")
def cellranger_count(infile, outfile):
    '''
    Docstring.
    '''
    
    sample_name = os.path.basename(outfile).replace(".done", "")
    
    job_threads = PARAMS["cellranger_threads"]
    
    job_memory_gb = PARAMS["cellranger_memory"]
    job_memory = PARAMS["cellranger_memory"] * 1024
    
    statement = """
    cellranger count --id=%(sample_name)s \
                   --libraries=data/%(sample_name)s_library.csv \
                   --transcriptome=/ifs/mirror/10xgenomics/refdata-cellranger-GRCh38-3.0.0 \
                   --feature-ref=data/%(sample_name)s_feature_ref.csv \
                   --expect-cells=1000
                   --jobmode=local
                   --localcores=%(job_threads)s
                   --localmem=%(job_memory_gb)s &&
    mv %(sample_name)s cellranger_count/ &&
    touch %(outfile)s
    """
    
    P.run(statement)

# ---------------------------------------------------
# Generic pipeline tasks
@follows(cellranger_count)
def full():
    pass


def main(argv=None):
    if argv is None:
        argv = sys.argv
    P.main(argv)


if __name__ == "__main__":
    sys.exit(P.main(sys.argv))
