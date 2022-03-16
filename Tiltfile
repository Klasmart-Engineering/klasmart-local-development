// include('./kidsloop-frontend/Tiltfile')
// include('./kidsloop-backend/Tiltfile')
include('../../repos/kidsloop-user-service/Tiltfile')

k8s_yaml('./infrastructure/k8s/pact-postgres-deployment.yaml')
k8s_yaml('./infrastructure/k8s/pact-broker-deployment.yaml')

k8s_resource('pact-postgres', labels=['pact-broker'], port_forwards=4455)
k8s_resource('pact-broker', labels=['pact-broker'], port_forwards=9292, resource_deps=['pact-postgres'])
