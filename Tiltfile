# load extensions
load('ext://git_resource', 'git_checkout')
load('./utils/Tiltfile', 'info')
load('./utils/Tiltfile', 'warn_missing_repo')


# local_resource(name='import_images', cmd='./import_images.sh')

# required
include('./common-infrastructure/Tiltfile')

# every service requires a helm chart from the central repository
if not os.path.exists('../kidsloop-helm-charts'):
    git_checkout('git@github.com:KL-Infrastructure/kidsloop-helm-charts.git', '../kidsloop-helm-charts')
else:
    info('skipping clone, the repository is already present: KL-Infrastructure/kidsloop-helm-charts')

# # optional resources, load only when repositories exist at the given path
# if os.path.exists('../cms-backend-service'):
#     load_dynamic('./cms-backend-service/Tiltfile')
# else:
#     warn_missing_repo('kidsloop-cms-service')
#
# if os.path.exists('../cms-frontend-service'):
#     load_dynamic('./cms-frontend-service/Tiltfile')
# else:
#     warn_missing_repo('cms-frontend-service')

if os.path.exists('../user-service'):
    load_dynamic('./user-service/Tiltfile')
else:
    warn_missing_repo('user-service')
#
# if os.path.exists('../kidsloop-xapi-service'):
#     load_dynamic('./xapi-service/Tiltfile')
# else:
#     warn_missing_repo('kidsloop-xapi-service')

if os.path.exists('../kidsloop-auth-server'):
    load_dynamic('./auth-backend-service/Tiltfile')
else:
    warn_missing_repo('kidsloop-auth-server')

if os.path.exists('../iam-auth-frontend'):
    load_dynamic('./auth-frontend-service/Tiltfile')
else:
    warn_missing_repo('iam-auth-frontend')

if os.path.exists('../kidsloop-hub-frontend'):
    load_dynamic('./hub-frontend/Tiltfile')
else:
    warn_missing_repo('hub-frontend')

# if os.path.exists('../kidsloop-assessment-service'):  # dynamodb hard dependency
#     load_dynamic('./assessment-service/Tiltfile')
# else:
#     warn_missing_repo('kidsloop-assessment-service')

# if os.path.exists('../kidsloop-pdf-service'): # dynamodb hard dependency
#     load_dynamic('./pdf-service/Tiltfile')
# else:
#     warn_missing_repo('kidsloop-pdf-service')

# if os.path.exists('../kidsloop-h5p-library'): # WIP
#     load_dynamic('./h5p-service/Tiltfile')
# else:
#     warn_missing_repo('kidsloop-h5p-library')



#k8s_resource(
#  objects=['auth-jwt-credentials:secret', 'live-jwt-credentials:secret', 'kidsloop-cms-backend-db:secret', 'kidsloop-pdf-service-db:secret', 'kidsloop-user-service-api:secret', 'kidsloop-user-service-db:secret', 'kidsloop-xapi-service-db:secret'],
#  new_name='secrets',
#  labels=['secrets'],
#)


