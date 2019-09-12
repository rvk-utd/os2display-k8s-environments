export CLOUDSDK_CORE_PROJECT=os2display-bbs
export CLOUDSDK_COMPUTE_REGION=europe-west2
# get-credentials for some reason uses the value of CLOUDSDK_COMPUTE_ZONE for
# the --region argument, so for now we'll give it a region here.
export CLOUDSDK_COMPUTE_ZONE=europe-west2
export CLOUDSDK_CONTAINER_CLUSTER=os2display-bbs-cluster-1

echo " * Configuring kubectl"
gcloud container clusters get-credentials $CLOUDSDK_CONTAINER_CLUSTER
kubens os2display-stage

echo " * Configuring helm"
helm init --client-only
helm repo add bbs-os2display https://reload.github.io/os2display-k8s

