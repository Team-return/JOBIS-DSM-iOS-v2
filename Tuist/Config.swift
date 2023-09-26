import ProjectDescription

let config = Config(
    plugins: [
        .local(path: .relativeToManifest("../../Plugins/EnviromentPlugin")),
        .local(path: .relativeToManifest("../../Plugins/DependencyPlugin"))
    ]
)
