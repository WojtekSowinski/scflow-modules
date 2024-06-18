FROM base_dependencies AS dge

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
install2.r -e -n -1 -s \
ggpubr \
tidyr \
htmltools \
stringr \
sctransform \
methods \
tidyselect \
ggrepel

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
Rscript -e 'requireNamespace("BiocManager"); \
BiocManager::install(c( \
"scater", \
"biomaRt", \
"edgeR", \
"limma", \
"MAST", \
"preprocessCore" \
), ask=F, update=F)'

WORKDIR scflowdge
RUN --mount=type=bind,target=.,source=. \
Rscript -e "devtools::check(vignettes = FALSE)"
RUN --mount=type=bind,target=.,source=. \
Rscript -e 'remotes::install_local(upgrade = "never")'

