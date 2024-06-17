#LABEL maintainer="Combiz Khozoie, Ph.D. c.khozoie@imperial.ac.uk, Alan Murphy, a.murphy@imperial.ac.uk"

## Use rstudio installs binaries from RStudio's RSPM service by default,
## Uses the latest stable ubuntu, R and Bioconductor versions. Created on unbuntu 20.04, R 4.3 and BiocManager 3.18
FROM rocker/rstudio:4.3 AS base_dependencies

## Re-enable apt cache to use cache mounts
RUN rm -f /etc/apt/apt.conf.d/docker-clean

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update \
	&& apt-get install -y --no-install-recommends \
        curl \
        cmake \
        libcurl4-openssl-dev \
        libicu-dev \
        libssl-dev \
        make \
        pandoc \
        pip \
        python3 \
        unzip \
        zlib1g-dev
	# && rm -rf /var/lib/apt/lists/*

RUN --mount=type=cache,target=/root/.cache/pip \
pip install stratocumulus \
&& curl https://sdk.cloud.google.com > install.sh \
&& bash install.sh --disable-prompts \
&& curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
-o "awscliv2.zip" \
&& unzip awscliv2.zip \
&& ./aws/install \
&& rm -rf awscliv2.zip install.sh /tmp/*


RUN --mount=type=cache,target=/tmp/downloaded_packages \
install2.r -e -n -1 -s \
        argparse \
        assertthat \
        BiocManager \
        cli \
        devtools \
        dplyr \
        DT \
        future \
        ggplot2 \
        grDevices \
        knitr \
        magrittr \
        Matrix \
        paletteer \
        purrr \
        qs \
        R.utils \
        RCurl \
        rlang \
        rmarkdown \
        stats \
        tools \
        utils

RUN --mount=type=cache,target=/tmp/downloaded_packages \
Rscript -e 'requireNamespace("BiocManager"); \
BiocManager::install(c( \
  "SingleCellExperiment", \
  "SummarizedExperiment" \
), ask=F, update=F)'

RUN --mount=type=cache,target=/tmp/downloaded_packages \
installGithub.r ropensci/plotly

# -----------------------------------------------------------------------------

FROM base_dependencies AS qc

RUN --mount=type=cache,sharing=locked,target=/var/cache/apt \
apt-get install -y --no-install-recommends \
libglpk-dev \
libxml2-dev \
libpng-dev

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
install2.r -e -n -1 -s \
ggpubr \
tidyr \
stringr \
sctransform \
english \
scales \
future.apply \
Seurat

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
Rscript -e 'requireNamespace("BiocManager"); \
BiocManager::install(c( \
"scater", \
"biomaRt", \
"DropletUtils" \
), ask=F, update=F)'

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
installGithub.r \ 
chris-mcginnis-ucsf/DoubletFinder \
ropensci/bib2df

WORKDIR scflowqc
RUN --mount=type=bind,target=.,source=. \
Rscript -e "devtools::check(vignettes = FALSE)"
RUN --mount=type=bind,target=.,source=. \
Rscript -e 'remotes::install_local(upgrade = "never")'

# -----------------------------------------------------------------------------

FROM base_dependencies AS merge

RUN --mount=type=cache,sharing=locked,target=/var/cache/apt \
apt-get install -y --no-install-recommends \
libglpk-dev \
libxml2-dev

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
install2.r -e -n -1 -s \
ggpubr \
tidyr \
htmltools \
stringr \
formattable \
threejs \
english \
Rtsne \
scales \
tidyselect \
ggdendro

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
Rscript -e 'requireNamespace("BiocManager"); \
BiocManager::install(c( \
"scater", \
"biomaRt", \
"edgeR" \
), ask=F, update=F)'

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
installGithub.r \ 
jlmelville/uwot \
cole-trapnell-lab/monocle3

# -----------------------------------------------------------------------------

FROM base_dependencies AS integrate

RUN --mount=type=cache,sharing=locked,target=/var/cache/apt \
apt-get install -y --no-install-recommends \
libglpk-dev \
libxml2-dev \
libhdf5-dev

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
install2.r -e -n -1 -s \
parallel

# install older version of rliger
RUN --mount=type=cache,target=/tmp/downloaded_packages \
Rscript -e 'remotes::install_version("rliger", version = "1.0.1", repos = "http://cran.r-project.org")'

# -----------------------------------------------------------------------------

FROM base_dependencies AS reddims

RUN --mount=type=cache,sharing=locked,target=/var/cache/apt \
apt-get install -y --no-install-recommends \
libglpk-dev \
libxml2-dev

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
install2.r -e -n -1 -s \
parallel \
threejs \
Rtsne

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
installGithub.r \ 
jlmelville/uwot \
cole-trapnell-lab/monocle3

# -----------------------------------------------------------------------------

FROM base_dependencies AS report_integ

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
install2.r -e -n -1 -s \
ggpubr \
parallel \
formattable \
UpSetR

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
installGithub.r \ 
theislab/kBET

# -----------------------------------------------------------------------------

FROM base_dependencies AS map_celltypes

RUN --mount=type=cache,sharing=locked,target=/var/cache/apt \
apt-get install -y --no-install-recommends \
libglpk-dev \
libxml2-dev \
libpng-dev \
gdal-bin \
libgdal-dev \
libgeos-dev \
libproj-dev \
libsqlite3-dev


RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
install2.r -e -n -1 -s \
parallel \
tidyr \
threejs \
EWCE \
leaflet \
plyr

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
installGithub.r \ 
NathanSkene/EWCE

# -----------------------------------------------------------------------------

FROM base_dependencies AS finalize

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
install2.r -e -n -1 -s \
ggpubr \
htmltools \
monocle3 \
formattable \
forcats \
ggridges \
Hmisc

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
installGithub.r \ 
cole-trapnell-lab/monocle3

# -----------------------------------------------------------------------------

FROM base_dependencies AS dge

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
install2.r -e -n -1 -s \
ggpubr \
tidyr \
htmltools \
stringr \
sctransform \
methods \
tidyselect \
ggrepel

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
Rscript -e 'requireNamespace("BiocManager"); \
BiocManager::install(c( \
"scater", \
"biomaRt", \
"edgeR", \
"limma", \
"MAST", \
"preprocessCore" \
), ask=F, update=F)'


# -----------------------------------------------------------------------------

FROM base_dependencies AS ipa

RUN --mount=type=cache,sharing=locked,target=/var/cache/apt \
apt-get install -y --no-install-recommends \
libglpk-dev \
libxml2-dev \
libpng-dev \
libfontconfig1-dev \
libfreetype6-dev \
perl

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
install2.r -e -n -1 -s \
parallel \
htmltools \
stringr \
cowplot \
enrichR \
WebGestaltR

WORKDIR scflowqc
RUN --mount=type=bind,target=.,source=. \
Rscript -e "devtools::check(vignettes = FALSE)"
RUN --mount=type=bind,target=.,source=. \
Rscript -e 'remotes::install_local(upgrade = "never")'

# -----------------------------------------------------------------------------

FROM base_dependencies AS dirichlet

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
install2.r -e -n -1 -s \
ggpubr \
tidyr \
htmltools \
sctransform \
methods \
tibble \
DirichletReg

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
Rscript -e 'requireNamespace("BiocManager"); \
BiocManager::install(c( \
"scater", \
"limma", \
"MAST", \
"preprocessCore" \
), ask=F, update=F)'
