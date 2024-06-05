## Use rstudio installs binaries from RStudio's RSPM service by default,
## Uses the latest stable ubuntu, R and Bioconductor versions. Created on unbuntu 20.04, R 4.3 and BiocManager 3.18
FROM rocker/r-ubuntu:20.04 AS build

## Add packages dependencies
RUN --mount=type=cache,target=/var/cache/apt \
apt-get update \
	&& apt-get install -y --no-install-recommends \
        apt-utils \
        cmake \
        curl \
        libcurl4-openssl-dev \
        libfontconfig1-dev \
        libfreetype6-dev \
        libfribidi-dev \
        libglpk-dev \
        libharfbuzz-dev \
        libicu-dev \
        libjpeg-dev \
        libpng-dev \
        libssl-dev \
        libtiff-dev \
        libxml2-dev \
        libcairo2-dev \
        make \
        pandoc \
        pip \
        python3 \
        qpdf \
        r-base \
        r-base-dev \
        unzip \
        zlib1g-dev \
	&& rm -rf /var/lib/apt/lists/*

# RUN --mount=type=cache,target=/root/.cache/pip \
# pip install stratocumulus \
# && curl https://sdk.cloud.google.com > install.sh \
# && bash install.sh --disable-prompts \
# && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
# -o "awscliv2.zip" \
# && unzip awscliv2.zip \
# && ./aws/install \
# && rm -rf awscliv2.zip install.sh /tmp/*

RUN --mount=type=cache,target=/tmp/downloaded_packages \
install2.r -e -t source \
        argparse \
        BiocManager \
        cli \
        devtools \
        future \
        future.apply \
        purrr \
        dplyr \
        grDevices \
        magrittr \
        stats \
        Matrix \
        stringr \
        english \
        tools \
        ggplot2 \
        rmarkdown \
        R.utils \
        qs \
        utils \
        assertthat \
        ggpubr \
        paletteer \
        Seurat \
        knitr \
        sctransform \
        DT \
        RCurl \
        plotly

## Install Bioconductor packages
COPY qc-requirements-bioc.R .
RUN --mount=type=cache,target=/tmp/downloaded_packages \
Rscript -e 'requireNamespace("BiocManager"); BiocManager::install(ask=F);' \
&& Rscript qc-requirements-bioc.R

## Install from GH the following
RUN --mount=type=cache,target=/tmp/downloaded_packages \
installGithub.r \
chris-mcginnis-ucsf/DoubletFinder \
ropensci/bib2df

WORKDIR scflowqc
RUN --mount=type=bind,target=.,source=. \
Rscript -e "devtools::check(vignettes = FALSE)" \
&& Rscript -e "remotes::install_local()"

FROM scratch as squash
COPY --from=build / /
