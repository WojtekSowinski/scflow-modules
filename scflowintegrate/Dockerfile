FROM base_dependencies AS integrate

RUN --mount=type=cache,sharing=locked,target=/var/cache/apt \
apt-get install -y --no-install-recommends \
libglpk-dev \
libxml2-dev \
libhdf5-dev \
patch

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
install2.r -e -n -1 -s \
parallel

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
Rscript -e 'requireNamespace("BiocManager"); \
BiocManager::install(c( \
"ComplexHeatmap" \
), ask=F, update=F)'

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
installGithub.r hhoeflin/hdf5r

# install older version of rliger
RUN --mount=type=cache,target=/tmp/downloaded_packages \
Rscript -e 'remotes::install_version("rliger", version = "1.0.1", repos = "http://cran.r-project.org")'

WORKDIR scflowintegrate
RUN --mount=type=bind,target=.,source=. \
Rscript -e "devtools::check(vignettes = FALSE)"
RUN --mount=type=bind,target=.,source=. \
Rscript -e 'remotes::install_local(upgrade = "never")'

