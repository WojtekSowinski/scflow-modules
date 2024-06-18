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

WORKDIR scflowipa
RUN --mount=type=bind,target=.,source=. \
Rscript -e "devtools::check(vignettes = FALSE)"
RUN --mount=type=bind,target=.,source=. \
Rscript -e 'remotes::install_local(upgrade = "never")'

