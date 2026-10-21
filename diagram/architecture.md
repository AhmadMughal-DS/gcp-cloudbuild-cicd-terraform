# Architecture Diagram — GCP CI/CD with Cloud Build

## Lucid diagram

- **Master Lucid document (all 30 diagrams, icon style):** https://lucid.app/lucidchart/3da75ce3-ea66-4296-81b3-00d20a60435b/edit
- This project is **page 27** of that document.

## Lucid prompt (reusable)

```
Create a GCP CI/CD diagram titled "GCP CI/CD with Cloud Build".
A developer runs gcloud builds submit, triggering Cloud Build. Cloud Build builds and
pushes an image to Artifact Registry, then deploys to Cloud Run; Cloud Run pulls the
image from Artifact Registry. Label the arrows. Clean, professional Google Cloud colors.
```

## Mermaid source

```mermaid
flowchart LR
    Dev([gcloud builds submit])
    CB[Cloud Build]
    AR[(Artifact Registry)]
    CR[Cloud Run]
    Dev --> CB
    CB -->|build + push| AR
    CB -->|deploy| CR
    AR -->|image| CR
```
