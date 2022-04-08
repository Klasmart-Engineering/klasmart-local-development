# load extensions
load('ext://git_resource', 'git_checkout')

# required
include('./shared-infrastructure/Tiltfile')

# requires helm chart repository
if not os.path.exists('../kidsloop-helm-charts'):
    git_checkout('git@github.com:KL-Infrastructure/kidsloop-helm-charts.git', '../kidsloop-helm-charts')

# optional, loaded if repositories exist on disk at the given path
if os.path.exists('../kidsloop-assessment-service'):
    load_dynamic('./assessment-service/Tiltfile')

if os.path.exists('../kidsloop-cms-service'):
    load_dynamic('./cms-backend-service/Tiltfile')

if os.path.exists('../cms-frontend-service'):
    load_dynamic('./cms-frontend-service/Tiltfile')

if os.path.exists('../user-service'):
    load_dynamic('./user-service/Tiltfile')

if os.path.exists('../kidsloop-xapi-service'):
    load_dynamic('./xapi-service/Tiltfile')

if os.path.exists('../kidsloop-auth-server'):
    load_dynamic('./auth-backend-service/Tiltfile')

if os.path.exists('../kidsloop-auth-frontend'):
    load_dynamic('./auth-frontend-service/Tiltfile')

if os.path.exists('../kidsloop-pdf-service'):
    load_dynamic('./pdf-service/Tiltfile')

if os.path.exists('../kidsloop-h5p-library'):
    load_dynamic('./h5p-service/Tiltfile')
