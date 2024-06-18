FROM base_dependencies AS dirichlet

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
install2.r -e -n -1 -s \
ggpubr \
tidyr \
htmltools \
sctransform \
methods \
tibble \
DirichletReg

RUN --mount=type=cache,sharing=locked,target=/tmp/downloaded_packages \
Rscript -e 'requireNamespace("BiocManager"); \
BiocManager::install(c( \
"scater", \
"limma", \
"MAST", \
"preprocessCore" \
), ask=F, update=F)'

WORKDIR scflowdirichlet
RUN --mount=type=bind,target=.,source=. \
Rscript -e "devtools::check(vignettes = FALSE)"
RUN --mount=type=bind,target=.,source=. \
Rscript -e 'remotes::install_local(upgrade = "never")'

