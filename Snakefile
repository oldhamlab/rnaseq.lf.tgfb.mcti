# Snakefile

# snakemake --use-conda -c 1

conda: "data-raw/mapping.yaml"

# SALMON = "/usr/local/anaconda3/envs/salmon/bin/salmon"
RUNS, = glob_wildcards("/Users/will/Desktop/rnaseq_lf_tgfb_mcti_BGI_2025/{run}/{run}_1.fq.gz")

rule all:
    input:
        expand("/Users/will/Desktop/rnaseq_lf_tgfb_mcti_BGI_2025/quants/{run}/quant.sf", run = RUNS)

rule transcriptome:
    output:
        "/Users/will/Desktop/index/gencode.v47.transcripts.fa.gz"
    shell:
        "wget ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/"
        "release_47/gencode.v47.transcripts.fa.gz -P /Users/will/Desktop/index"

rule genome:
    output:
        "/Users/will/Desktop/index/GRCh38.primary_assembly.genome.fa.gz"
    shell:
        "wget ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/"
        "release_47/GRCh38.primary_assembly.genome.fa.gz -P /Users/will/Desktop/index"

rule decoys:
    input:
        genome = "/Users/will/Desktop/index/GRCh38.primary_assembly.genome.fa.gz"
    output:
        "/Users/will/Desktop/index/decoys.txt"
    run:
        shell("grep '^>' <(gunzip -c {input.genome}) |"
        "cut -d ' ' -f 1 > /Users/will/Desktop/index/decoys.txt")
        shell("sed -i.bak -e 's/>//g' /Users/will/Desktop/index/decoys.txt")

rule combined:
    input:
        transcripts = "/Users/will/Desktop/index/gencode.v47.transcripts.fa.gz",
        genome = "/Users/will/Desktop/index/GRCh38.primary_assembly.genome.fa.gz"
    output:
        "/Users/will/Desktop/index/gentrome.fa.gz"
    shell:
        "cat {input.transcripts} {input.genome} > "
        "/Users/will/Desktop/index/gentrome.fa.gz"

rule index:
    input:
        seq = "/Users/will/Desktop/index/gentrome.fa.gz",
        decoy = "/Users/will/Desktop/index/decoys.txt"
    output:
        directory("/Users/will/Desktop/index/index")
    shell:
        "salmon index --gencode -p 7 -t {input.seq} -d {input.decoy} -i {output}"

rule quant:
    input:
        r1 = "/Users/will/Desktop/rnaseq_lf_tgfb_mcti_BGI_2025/{sample}/{sample}_1.fq.gz",
        r2 = "/Users/will/Desktop/rnaseq_lf_tgfb_mcti_BGI_2025/{sample}/{sample}_2.fq.gz",
        index = "/Users/will/Desktop/index/index"
    output:
        "/Users/will/Desktop/rnaseq_lf_tgfb_mcti_BGI_2025/quants/{sample}/quant.sf"
    params:
        dir = "/Users/will/Desktop/rnaseq_lf_tgfb_mcti_BGI_2025/quants/{sample}"
    shell:
        "salmon quant -i {input.index} -l A -p 7 --gcBias -o {params.dir}"
        " -1 {input.r1} -2 {input.r2}"
