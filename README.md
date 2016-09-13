# Companion - Mac Native Execution Fork

A portable, scalable eukaryotic genome annotation pipeline implemented in Nextflow.

*NOTE:* This is a specific fork of companion used for testing stability of bioinformatics pipelines across machines and platforms. It is not intended for real-world use.

**INSTALL:** To run this fork natively on Mac OSX, a large number of dependancies are needed, including but not limited to:

* blast2
* blast+
* snap
* mummer
* infernal
* hmmer
* exonerate
* mafft
* fasttree
* circos
* genometools
* tantan
* aragorn
* boost
* augustus
* mlc
* lp_solve
* netcat
* bio-perl
* libsvg
* libgd
* libgsl
* libgsl2
* suiteparse
* esl2
* last-align
* orthomcl
* abacus2
* ratt
* perl
* lua

This fork comes with the *Leishmania infantum* genome in the example-data folder and is set to annotate this genome by default.

The results after this execution can be found in the folder mac_local_results

Everything after this line in the README is for the default Companion and may not be specific to this fork.

### [Purpose](#platforms)

This software is a comprehensive computational pipeline for the annotation of
eukaryotic genomes (like protozoan parasites). It performs the following tasks:

  - Fast generation of pseudomolecules from scaffolds by ordering and orientating against a reference
  - Accurate transfer of highly conserved gene models from the reference
  - _De novo_ gene finding as a complement to the gene transfer
  - Non-coding RNA detection (tRNA, rRNA, sn(o)RNA, ...)
  - Pseudogene detection
  - Functional annotation (GO, products, ...)
    - ...by transferring reference annotations to the target genome
    - ...by inferring GO terms and products from Pfam pHMM matches
  - Consistent gene ID assignment
  - Preparation of validated GFF3, GAF and EMBL output files for jump-starting manual curation and quick turnaround time to submission

It supports parallelized execution on a single machine as well as on large cluster platforms (LSF, SGE, ...).

### [Requirements](#requirements)

The pipeline is built on [Nextflow](http://nextflow.io) as a workflow engine, so it needs to be installed first:
```
curl -fsSL get.nextflow.io | bash
```

With Nextflow installed, the easiest way to use the pipeline is to use the prepared Docker container (https://hub.docker.com/r/satta/companion/) which contains all external dependencies.
```
docker pull satta/companion
```

### [Running the pipeline](#running)

Here's how to start an example run using Docker (using the example dataset and parameterization included in the distribution):
```
$ nextflow run sanger-pathogens/companion -profile docker
```

For your own runs, provide your own file names, paths, parameters, etc. as defined in the `nextflow.config` file.

### [Preparing reference annotations](#reference)

The reference annotations used in the pipeline need to be pre-processed before they can be used.
See [the HOWTO on the GitHub wiki](https://github.com/sanger-pathogens/companion/wiki/Preparing-reference-data-sets) for more details. There are also pre-generated reference sets for various parasite species/families. Please contact the authors via the email address below to obtain them.

### [Contact](#contact)

Sascha Steinbiss (ss34@sanger.ac.uk)

###[Build status](#build)

![Travis status](https://travis-ci.org/sanger-pathogens/companion.svg)
