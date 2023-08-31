# Snakefile

# snakemake --use-conda -c 1

conda: "data-raw/mapping.yaml"

SALMON = "/usr/local/anaconda3/envs/salmon/bin/salmon"
RUNS, = glob_wildcards("data-raw/merge/{run}_1.fq.gz")

rule all:
    input:
        expand("data-raw/quants/{run}/quant.sf", run = RUNS)

rule transcriptome:
    output:
        "data-raw/gencode.v44.transcripts.fa.gz"
    shell:
        "wget ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/"
        "release_44/gencode.v44.transcripts.fa.gz -P data-raw/"

rule genome:
    output:
        "data-raw/GRCh38.primary_assembly.genome.fa.gz"
    shell:
        "wget ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/"
        "release_44/GRCh38.primary_assembly.genome.fa.gz -P data-raw/"

rule decoys:
    output:
        "data-raw/decoys.txt"
    shell:
        "grep '^>' <(gunzip -c data-raw/GRCh38.primary_assembly.genome.fa.gz) |"
        "cut -d ' ' -f 1 > data-raw/decoys.txt"

rule combined:
    output:
        "data-raw/gentrome.fa.gz"
    shell:
        "cat data-raw/gencode.v44.transcripts.fa.gz "
        "data-raw/GRCh38.primary_assembly.genome.fa.gz > "
        "data-raw/gentrome.fa.gz"

rule index:
    input:
        seq = "data-raw/gentrome.fa.gz",
        decoy = "data-raw/decoys.txt"
    output:
        directory("data-raw/index")
    shell:
        "{SALMON} index --gencode -p 7 -t {input.seq} -d {input.decoy} -i {output}"

rule quant:
    input:
        r1 = "data-raw/merge/{sample}_1.fq.gz",
        r2 = "data-raw/merge/{sample}_2.fq.gz",
        index = "data-raw/index"
    output:
        "data-raw/quants/{sample}/quant.sf"
    params:
        dir = "data-raw/quants/{sample}"
    shell:
        "{SALMON} quant -i {input.index} -l A -p 7 --gcBias -o {params.dir}"
        " -1 {input.r1} -2 {input.r2}"
