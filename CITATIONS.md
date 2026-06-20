# Citations

This pipeline uses the following software, containers, and public test data.

## Workflow engine

### Nextflow

Di Tommaso P, Chatzou M, Floden EW, Barja PP, Palumbo E, Notredame C.  
Nextflow enables reproducible computational workflows.  
*Nature Biotechnology* 2017;35:316–319.  
https://doi.org/10.1038/nbt.3820

Website: https://www.nextflow.io/

## HLA typing

### OptiType

Szolek A, Schubert B, Mohr C, Sturm M, Feldhahn M, Kohlbacher O.  
OptiType: precision HLA typing from next-generation sequencing data.  
*Bioinformatics* 2014;30(23):3310–3316.  
https://doi.org/10.1093/bioinformatics/btu548

Software: https://github.com/FRED-2/OptiType

## Read processing

### BWA

Li H, Durbin R.  
Fast and accurate short read alignment with Burrows-Wheeler transform.  
*Bioinformatics* 2009;25(14):1754–1760.  
https://doi.org/10.1093/bioinformatics/btp324

Software: https://github.com/lh3/bwa

### samtools

Li H, Handsaker B, Wysoker A, Fennell T, Ruan J, Homer N, et al.  
The Sequence Alignment/Map format and SAMtools.  
*Bioinformatics* 2009;25(16):2078–2079.  
https://doi.org/10.1093/bioinformatics/btp352

Website: https://www.htslib.org/

### 10X Genomics bamtofastq

The pipeline uses `bamtofastq` to convert 10X Genomics BAM files back to FASTQ format.

Tool information: https://bioconda.github.io/recipes/10x_bamtofastq/README.html

## Containers

The pipeline uses Singularity/Apptainer containers from the Galaxy Depot container registry.

Galaxy Depot: https://depot.galaxyproject.org/singularity/

## Test data

The test profile downloads a public 10X Genomics 5' single-cell RNA-seq BAM file and index file from the PBMC 1k dataset.

Dataset source: https://www.10xgenomics.com/datasets/1-k-pbm-cs-from-a-healthy-donor-v-2-chemistry-2-standard-4-0-0