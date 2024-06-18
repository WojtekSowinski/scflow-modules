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

