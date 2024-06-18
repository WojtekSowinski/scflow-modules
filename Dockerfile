# Install dependencies needed by most of the packages in this repository

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

