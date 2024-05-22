bioc_pkgs<-c(
  'DropletUtils',
  'SingleCellExperiment',
  'SummarizedExperiment',
  'biomaRt',
  'scater'
)

requireNamespace("BiocManager")
BiocManager::install(bioc_pkgs, ask=F, type = "source")
