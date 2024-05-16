bioc_pkgs<-c(
  'DropletUtils',
  'SingleCellExperiment',
  'SummarizedExperiment'
)

requireNamespace("BiocManager")
BiocManager::install(bioc_pkgs, ask=F, type = "source")
