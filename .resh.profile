echo " * Configuring kubectl"
gcloud --project=os2display-bbs container clusters get-credentials --region=europe-west2 os2display-bbs-cluster-1
kubens os2display-stage

echo " * Configuring helm"
helm init --client-only
helm repo add bbs-os2display https://reload.github.io/os2display-k8s
