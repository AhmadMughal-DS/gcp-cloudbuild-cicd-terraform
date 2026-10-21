output "artifact_registry_repo" {
  value = google_artifact_registry_repository.this.repository_id
}
output "cloud_run_url" {
  value = google_cloud_run_v2_service.this.uri
}
