data "google_project" "this" {}

locals {
  name          = var.project_name
  cloudbuild_sa = "serviceAccount:${data.google_project.this.number}@cloudbuild.gserviceaccount.com"
}

############################
# Artifact Registry (Docker)
############################
resource "google_artifact_registry_repository" "this" {
  location      = var.region
  repository_id = local.name
  format        = "DOCKER"
  description   = "Images built by Cloud Build"
}

############################
# Cloud Run service (deploy target)
############################
resource "google_cloud_run_v2_service" "this" {
  name     = "${local.name}-svc"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
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
# Cloud Build service account permissions
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
