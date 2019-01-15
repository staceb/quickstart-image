workflow "New workflow" {
  on = "push"
  resolves = ["Docker Push"]
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
    "DOCKER_PASSWORD",
  ]
}

action "Docker Push" {
  uses = "actions/docker/login@c08a5fc9e0286844156fefff2c141072048141f6"
  needs = ["Docker Login"]
  args = "push gcr.io/vocal-operand-228712/quickstart-image"
}
