requireNamespace("remotes")
# all-imports contains all R packages imported by ScFlow.
# These were copied form the DESCRIPTION file in the ScFlow repository
pkgs <- readLines("all-imports")
for (pkg in pkgs) {
    deps <- remotes::system_requirements("ubuntu", os_release="22.04", path=".", package=pkg)
    # cat(pkg, fill=TRUE)
    for (dep in deps) {
        cat(tail(strsplit(dep,split=" ")[[1]],1), fill=TRUE)
    }
    cat("\n")
}

