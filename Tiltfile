#include('./assessment-service/Tiltfile')  # dynamodb hard dependency
include('./cms-backend-service/Tiltfile')
include('./cms-frontend-service/Tiltfile')
include('./user-service/Tiltfile')
include('./xapi-service/Tiltfile')
include('./auth-backend-service/Tiltfile')
include('./auth-frontend-service/Tiltfile')
#include('./pdf-service/Tiltfile')  # dynamodb hard dependency
#include('./h5p-service/Tiltfile') # WIP

#k8s_resource(
#  objects=['auth-jwt-credentials:secret', 'live-jwt-credentials:secret', 'kidsloop-cms-backend-db:secret', 'kidsloop-pdf-service-db:secret', 'kidsloop-user-service-api:secret', 'kidsloop-user-service-db:secret', 'kidsloop-xapi-service-db:secret'],
#  new_name='secrets',
#  labels=['secrets'],
#)

k8s_yaml('./infrastructure/k8s/pact-postgres-deployment.yaml')
k8s_yaml('./infrastructure/k8s/pact-broker-deployment.yaml')

load('ext://helm_remote', 'helm_remote')
helm_remote(chart='localstack', repo_url='https://helm.localstack.cloud', repo_name='localstack-repo', values='localstack/values.yaml')
k8s_resource('localstack', labels=['localstack'], port_forwards=4566)

k8s_resource('pact-postgres', labels=['pact-broker'])
k8s_resource('pact-broker', labels=['pact-broker'], port_forwards='9292:9292', resource_deps=['pact-postgres'])
