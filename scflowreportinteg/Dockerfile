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

WORKDIR scflowreportinteg
RUN --mount=type=bind,target=.,source=. \
Rscript -e "devtools::check(vignettes = FALSE)"
RUN --mount=type=bind,target=.,source=. \
Rscript -e 'remotes::install_local(upgrade = "never")'

