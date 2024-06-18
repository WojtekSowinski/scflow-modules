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
leaflet \
plyr

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
Rscript -e 'requireNamespace("BiocManager"); \
BiocManager::install(c( \
"orthogene" \
), ask=F, update=F)'

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
installGithub.r NathanSkene/EWCE

WORKDIR scflowmapcelltypes
RUN --mount=type=bind,target=.,source=. \
Rscript -e "devtools::check(vignettes = FALSE)"
RUN --mount=type=bind,target=.,source=. \
Rscript -e 'remotes::install_local(upgrade = "never")'

