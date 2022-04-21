#!/bin/bash

local_registry="registry.local:5000"
remote_registry="942095822719.dkr.ecr.eu-west-2.amazonaws.com"
profile="kl-int-infra"
region="eu-west-2"
login_retries=3

function ecr_login () {
  echo "INFO: Logging on via SSO.... make sure that you have profile: $profile configured"
  aws sso login --profile $profile
  aws ecr get-login-password --region $region --profile $profile | docker login --username AWS --password-stdin $remote_registry
}

# set of images to import
declare -A images=( ["kidsloop-auth-frontend:azure-loadtest-b343a19"]="auth-frontend"
                    ["kidsloop-cms-frontend:kidskube-loadtest-92b5b01"]="cms-frontend")


for i in $(seq $login_retries); do
  for source_img in "${!images[@]}";do

    img_split=(${source_img//:/ })
    source_tag=${img_split[1]}

    echo "INFO: pulling $remote_registry/$source_img"
    docker pull "$remote_registry/$source_img" || (ecr_login && break)

    echo "INFO: tagging $remote_registry/$source_img $local_registry/${images[$source_img]}:$source_tag"
    docker tag "$remote_registry/$source_img" "$local_registry/${images[$source_img]}:$source_tag"

    echo "INFO: pushing $local_registry/${images[$source_img]}:$source_tag"
    docker push "$local_registry/${images[$source_img]}:$source_tag"
  done
  exit $?
done


