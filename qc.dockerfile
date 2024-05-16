#LABEL maintainer="Combiz Khozoie, Ph.D. c.khozoie@imperial.ac.uk, Alan Murphy, a.murphy@imperial.ac.uk"

## Use rstudio installs binaries from RStudio's RSPM service by default,
## Uses the latest stable ubuntu, R and Bioconductor versions. Created on unbuntu 20.04, R 4.3 and BiocManager 3.18
FROM rocker/rstudio:4.3


## Add packages dependencies
RUN --mount=type=cache,target=/var/cache/apt \
apt-get update \
	&& apt-get install -y --no-install-recommends apt-utils \
	&& apt-get install -y --no-install-recommends \
	## Basic deps
	gdb \
	libxml2-dev \
	python3-pip \
	libz-dev \
	liblzma-dev \
	libbz2-dev \
	libpng-dev \
	libgit2-dev \
	## sys deps from bioc_full
	pkg-config \
	fortran77-compiler \
	byacc \
	automake \
	curl \
	## This section installs libraries
	## Additional resources
	xfonts-100dpi \
	xfonts-75dpi \
	biber \
	libsbml5-dev \
	## qpdf needed to stop R CMD Check warning
	qpdf \
	gcc \
	&& rm -rf /var/lib/apt/lists/*

RUN pip install stratocumulus \
&& curl https://sdk.cloud.google.com > install.sh \
&& bash install.sh --disable-prompts \
&& curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
-o "awscliv2.zip" \
&& unzip awscliv2.zip \
&& ./aws/install \
&& rm -rf awscliv2.zip \
&& rm -rf /tmp/*


RUN --mount=type=cache,target=/tmp/downloaded_packages \
install2.r -e -t source \
BiocManager \
argparse \
cli \
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
sctransform \

## biomaRt DropletUtils SingleCellExperiment SummarizedExperiment

## Install Bioconductor packages
COPY qc-requirements-bioc.R .
RUN --mount=type=cache,target=/tmp/downloaded_packages \
Rscript -e 'requireNamespace("BiocManager"); BiocManager::install(ask=F);' \
&& Rscript qc-requirements-bioc.R \

## Install from GH the following
RUN --mount=type=cache,target=/tmp/downloaded_packages \
installGithub.r \
chris-mcginnis-ucsf/DoubletFinder \
ropensci/bib2df \

## Install scFlow package
# Copy description
WORKDIR scFlow
ADD . .

# Run R CMD check - will fail with any errors or warnings
RUN Rscript -e "devtools::check(vignettes = FALSE)"
# Install R package from source
RUN Rscript -e "remotes::install_local()"
RUN rm -rf *
