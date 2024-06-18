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
igraph \
ggdendro

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
Rscript -e 'requireNamespace("BiocManager"); \
BiocManager::install(c( \
"scater", \
"biomaRt", \
"batchelor", \
"edgeR" \
), ask=F, update=F)'

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
installGithub.r \ 
jlmelville/uwot \
cole-trapnell-lab/monocle3

WORKDIR scflowmerge
RUN --mount=type=bind,target=.,source=. \
Rscript -e "devtools::check(vignettes = FALSE)"
RUN --mount=type=bind,target=.,source=. \
Rscript -e 'remotes::install_local(upgrade = "never")'

