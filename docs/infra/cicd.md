# CI/CD

Each service has its own `Jenkinsfile`.

## Pipeline Stages

- `SCM`
- `Dependencies`
- `Build`
- `Push to Docker Hub`
- `Deploy to K8s`

## Jenkins

The local Jenkins helper is in `jenkins/compose.yaml`.

Expected credentials:

- `dockerhub-credential`
- `kubeconfig`
