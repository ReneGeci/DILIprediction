# Integrating in vivo and in silico approaches enables prediction of drug-induced liver injury
___

by
René Geci,
Ahenk Zeynep Sayin,
Stephan Schaller,
Lars Kuepfer

now available in Archives of Toxicology: https://doi.org/10.1007/s00204-026-04305-2
___

## Overview

> The repository contains the following
> 1. `code + figures`: the code required to reproduce simulation results and figures
> 2. `data`: the data collected from literature and generated during simulations
> 3. `model files`: the PBK model files of each drug which can be investigated in detail using  MoBi and the PBBA model file
___


## Getting the files
You can download a copy of all the files in this repository by cloning this repository:

    git clone https://github.com/ReneGeci/DILIprediction.git

or [download a zip archive](https://github.com/ReneGeci/DILIprediction/archive/master.zip).


## Investigating the code
A R markdown file containing the code that produces all publication figures can be found in `code + figures`. The corresponding .html file also shows the direct code outputs like plots.

To re-run PBK and PBBA model simulations, you need to at least install the Open Systems pharmacology suite, its R package and all package dependencies required.

To learn more about the installation of the Open Systems Pharmacology suite (PK-Sim & MoBi) go to the [OSP webpage](https://www.open-systems-pharmacology.org/).

For an explanation how to install the OSP R package, go here: [OSP github](https://github.com/open-systems-pharmacology/ospsuite-r).

For documentation and explanation how the OSP R package works, go here: [OSP R webpage](https://www.open-systems-pharmacology.org/OSPSuite-R/).


## Funding
This work was performed in the context of the ONTOX project (https://ontoxproject.eu/) that has received funding from the European Union’s Horizon 2020 Research and Innovation programme under grant agreement No 963845. ONTOX is part of the ASPIS project cluster (https://aspiscluster.eu/). AZS and LK acknowledge financial support by the German Federal Ministry of Education and Research (BMBF), grant number 03LW0304K