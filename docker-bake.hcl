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
        "dirichlet",
    ]
}
target "qc" {
    dockerfile = "../split.dockerfile"
    tags = ["my_scflow/split:qc"]
    target = "qc"
    context = "./scflowqc"
}
target "merge" {
    dockerfile = "../split.dockerfile"
    tags = ["my_scflow/split:merge"]
    target = "merge"
    context = "./scflowqc"
}
target "integrate" {
    dockerfile = "../split.dockerfile"
    tags = ["my_scflow/split:integrate"]
    target = "integrate"
    context = "./scflowqc"
}
target "reddims" {
    dockerfile = "../split.dockerfile"
    tags = ["my_scflow/split:reddims"]
    target = "reddims"
    context = "./scflowqc"
}
target "report_integ" {
    dockerfile = "../split.dockerfile"
    tags = ["my_scflow/split:report_integ"]
    target = "report_integ"
    context = "./scflowqc"
}
target "map_celltypes" {
    dockerfile = "../split.dockerfile"
    tags = ["my_scflow/split:map_celltypes"]
    target = "map_celltypes"
    context = "./scflowqc"
}
target "finalize" {
    dockerfile = "../split.dockerfile"
    tags = ["my_scflow/split:finalize"]
    target = "finalize"
    context = "./scflowqc"
}
target "dge" {
    dockerfile = "../split.dockerfile"
    tags = ["my_scflow/split:dge"]
    target = "dge"
    context = "./scflowqc"
}
target "ipa" {
    dockerfile = "../split.dockerfile"
    tags = ["my_scflow/split:ipa"]
    target = "ipa"
    context = "./scflowIPA"
}
target "dirichlet" {
    dockerfile = "../split.dockerfile"
    tags = ["my_scflow/split:dirichlet"]
    target = "dirichlet"
    context = "./scflowqc"
}
