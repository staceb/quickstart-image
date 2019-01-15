workflow "New workflow" {
  on = "push"
  resolves = ["GitHub Action for Google Cloud SDK auth"]
}

action "Build" {
  uses = "actions/docker/cli@76ff57a6c3d817840574a98950b0c7bc4e8a13a8"
  args = "build -t quickstart-image ."
}

action "Docker Tag" {
  uses = "actions/docker/tag@76ff57a6c3d817840574a98950b0c7bc4e8a13a8"
  needs = ["Build"]
  args = "quickstart-image gcr.io/vocal-operand-228712/quickstart-image"
}

action "Docker Login" {
  uses = "actions/docker/cli@76ff57a6c3d817840574a98950b0c7bc4e8a13a8"
  needs = ["Docker Tag"]
  secrets = [
    "DOCKER_USERNAME",
    "DOCKER_REGISTRY_URL",
    "DOCKER_PASSWORD"
  ]
}
