resource "github_repository" "recall" {
  name        = "recall"
  description = ""

  visibility = "public"
  auto_init = true
}

resource "github_branch" "master" {
  repository = github_repository.recall.name
  branch     = "master"
}

resource "github_branch_default" "default"{
  repository = github_repository.recall.name
  branch     = github_branch.master.branch
}