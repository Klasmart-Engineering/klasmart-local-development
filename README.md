# kidsloop-local-development

## Installation
Run the K3D installation script:
```shell
k3d-with-registry.sh
```

## Create an AzureB2C Tenant for local development
Setup an account at: https://portal.azure.com/
Type 'B2C Tenants' into the search box and then create a tenant in the following screen.

## Create a backend service from the cookiecutter template

### Prerequisites
Install pyenv
```shell
pyenv install 3.9.0
```
Create a virtual environment
```shell
~/.pyenv/versions/3.9.0/bin/python3.9 -m venv venv39
```
Activate venv
```shell
source venv39/bin/activate
```

Install cookiecutter
```shell
pip install cookiecutter
```

Create a directory for storing a local shared Terraform state
```shell
mkdir ~/Users/my_system_name/terraform_shared_state
```

Navigate to the directory where you want to keep your kidsloop repositories.

Create a backend skeleton service
```shell
cookiecutter gh:KL-Engineering/kidsloop-backend-template
```

Follow the instructions in the generated README.

Create a frontend skeleton site
```shell
cookiecutter gh:KL-Engineering/kidsloop-frontend-template
```

Add the paths for your generated Tiltfile/s to the Tilefile in this repo. Change the names accordingly:
```starlark
include('./kidsloop-backend/Tiltfile')
include('./kidsloop-frontend/Tiltfile')
```

## Tilt

> :warning: Work In Progress!

The main `Tiltfile` is configured to do two things:

1. Clone the `KL-Infrastructure/kidsloop-helm-charts`:
   - You must have access to the KL-Infrastructure GitHub Organisation,
   - Helm charts are required to create each service in the cluster, 
   - It will not clone if the repository is already present.
3. Optionally, load each service:
   - The service repository must be cloned for Tilt to load the resource into the cluster,
   - This allows you to only work on a single service at a time, i.e. if you only have `cms-backend-service` clones, only that will load. If an expected resource isn't loading, look at the Tilt logs for details,
   - If you have more clones, you can still use Tilt features to only load resources you care about, e.g. `tilt up cms-backend-service` - see [documentation](https://docs.tilt.dev) for further details.