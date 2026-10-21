data "google_project" "this" {}

locals {
  labels        = { project = var.name_prefix, environment = var.environment, managed_by = "terraform", owner = "muhammad-ahmad" }
  cloudbuild_sa = "serviceAccount:${data.google_project.this.number}@cloudbuild.gserviceaccount.com"
}

resource "google_artifact_registry_repository" "this" {
  location      = var.region
  repository_id = var.name_prefix
  format        = "DOCKER"
  description   = "Images built by Cloud Build"
  labels        = local.labels

  cleanup_policies {
    id     = "keep-recent"
    action = "KEEP"
    most_recent_versions {
      keep_count = 10
    }
  }
}

resource "google_service_account" "run" {
  account_id   = "${var.name_prefix}-run"
  display_name = "Cloud Run runtime SA"
}

resource "google_cloud_run_v2_service" "this" {
  name     = "${var.name_prefix}-svc"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = google_service_account.run.email
    labels          = local.labels
    containers {
      image = var.initial_image
    }
  }
}

resource "google_cloud_run_v2_service_iam_member" "public" {
  name     = google_cloud_run_v2_service.this.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}

############################
# Cloud Build permissions
############################
resource "google_project_iam_member" "cb_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = local.cloudbuild_sa
}

resource "google_project_iam_member" "cb_sa_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = local.cloudbuild_sa
}

resource "google_project_iam_member" "cb_artifact_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = local.cloudbuild_sa
}
