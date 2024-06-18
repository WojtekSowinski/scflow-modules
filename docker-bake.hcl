group "default" {
    targets = [
        "qc",
        "merge",
        "integrate",
        "reddims",
        "report_integ",
        "map_celltypes",
        "finalize",
        "dge",
        "ipa",
        "dirichlet"
    ]
}
target "base" {
    target = "base_dependencies"
    tags = ["my_scflow/base_deps"]
}
target "qc" {
    tags = ["my_scflow/qc"]
    target = "qc"
    context = "./scflowqc"
    contexts = {
        base_dependencies = "target:base"
    }
}
target "merge" {
    tags = ["my_scflow/merge"]
    target = "merge"
    context = "./scflowmerge"
    contexts = {
        base_dependencies = "target:base"
    }
}
target "integrate" {
    tags = ["my_scflow/integrate"]
    target = "integrate"
    context = "./scflowintegrate"
    contexts = {
        base_dependencies = "target:base"
    }
}
target "reddims" {
    tags = ["my_scflow/reddims"]
    target = "reddims"
    context = "./scflowreddims"
    contexts = {
        base_dependencies = "target:base"
    }
}
target "report_integ" {
    tags = ["my_scflow/report_integ"]
    target = "report_integ"
    context = "./scflowreportinteg"
    contexts = {
        base_dependencies = "target:base"
    }
}
target "map_celltypes" {
    tags = ["my_scflow/map_celltypes"]
    target = "map_celltypes"
    context = "./scflowmapcelltypes"
    contexts = {
        base_dependencies = "target:base"
    }
}
target "finalize" {
    tags = ["my_scflow/finalize"]
    target = "finalize"
    context = "./scflowfinalize"
    contexts = {
        base_dependencies = "target:base"
    }
}
target "dge" {
    tags = ["my_scflow/dge"]
    target = "dge"
    context = "./scflowdge"
    contexts = {
        base_dependencies = "target:base"
    }
}
target "ipa" {
    tags = ["my_scflow/ipa"]
    target = "ipa"
    context = "./scflowipa"
    contexts = {
        base_dependencies = "target:base"
    }
}
target "dirichlet" {
    tags = ["my_scflow/dirichlet"]
    target = "dirichlet"
    context = "./scflowdirichlet"
    contexts = {
        base_dependencies = "target:base"
    }
}
