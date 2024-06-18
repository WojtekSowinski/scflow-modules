FROM base_dependencies AS finalize

RUN --mount=type=cache,sharing=locked,target=/var/cache/apt \
apt-get install -y --no-install-recommends \
libglpk-dev \
libxml2-dev

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
install2.r -e -n -1 -s \
ggpubr \
htmltools \
formattable \
forcats \
ggridges \
igraph \
Hmisc

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
Rscript -e 'requireNamespace("BiocManager"); \
BiocManager::install(c( \
"batchelor" \
), ask=F)'

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
installGithub.r cole-trapnell-lab/monocle3

WORKDIR scflowfinalize
RUN --mount=type=bind,target=.,source=. \
Rscript -e "devtools::check(vignettes = FALSE)"
RUN --mount=type=bind,target=.,source=. \
Rscript -e 'remotes::install_local(upgrade = "never")'

