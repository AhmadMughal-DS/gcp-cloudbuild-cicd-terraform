output "artifact_registry_repo" {
  description = "Artifact Registry Docker repo"
  value       = google_artifact_registry_repository.this.repository_id
}

output "cloud_run_url" {
  description = "Public URL of the Cloud Run service"
  value       = google_cloud_run_v2_service.this.uri
}

output "submit_build_command" {
  description = "Run a build + deploy from the repo root"
  value       = "gcloud builds submit --config cloudbuild.yaml --substitutions=_REGION=${var.region},_REPO=${google_artifact_registry_repository.this.repository_id},_SERVICE=${google_cloud_run_v2_service.this.name}"
}
