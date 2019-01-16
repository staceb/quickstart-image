workflow "GCloud" {
  on = "release"
  resolves = ["Push image to GCR"]
}

action "Build Docker image" {
  uses = "actions/docker/cli@76ff57a6c3d817840574a98950b0c7bc4e8a13a8"
  args = "build -t quickstart-image ."
}

action "Setup Google Cloud" {
  needs = ["Build Docker image"]
  uses = "actions/gcloud/auth@master"
  secrets = ["GCLOUD_AUTH"]
}

action "Tag image for GCR" {
  needs = ["Setup Google Cloud"]
  uses = "actions/docker/tag@master"
  env = {
    PROJECT_ID = "vocal-operand-228712"
    APPLICATION_NAME = "quickstart-image"
  }
  args = ["quickstart-image", "gcr.io/$PROJECT_ID/$APPLICATION_NAME"]
}

action "Set Credential Helper for Docker" {
  needs = ["Tag image for GCR"]
  uses = "actions/gcloud/cli@master"
  args = ["auth", "configure-docker", "--quiet"]
}

action "Push image to GCR" {
  needs = ["Set Credential Helper for Docker"]
  uses = "actions/gcloud/cli@master"
  runs = "sh -c"
  env = {
    PROJECT_ID = "vocal-operand-228712"
    APPLICATION_NAME = "quickstart-image"
  }
  args = ["docker push gcr.io/$PROJECT_ID/$APPLICATION_NAME"]
}

