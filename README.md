# kidsloop-local-development

## Installation
Run the K3D installation script:
```k3d-with-registry.sh```

## Create an AzureB2C Tenant for local development
Setup an account at: https://portal.azure.com/
Type 'B2C Tenants' into the search box and then create a tenant in the following screen.

## Create a backend service from the cookiecutter template

### Prerequisites
Install pyenv
```pyenv install 3.9.0```
Create a virtual environment
```~/.pyenv/versions/3.9.0/bin/python3.9 -m venv venv39```
Activate venv
```source venv39/bin/activate```

Create a directory for storing a local shared Terraform state
```mkdir ~/Users/my_system_name/terraform_shared_state```

Navigate to the directory where you want to keep your kidsloop repositories.

Create a backend skeleton service
```cookiecutter gh:KL-Engineering/kidsloop-backend-template```

Follow the instructions in the generated README.

Create a frontend skeleton site
```cookiecutter gh:KL-Engineering/kidsloop-frontend-template```

Add the paths for your generated Tiltfile/s to the Tilefile in this repo. Change the names accordingly:
```include('./kidsloop-backend/Tiltfile')```
```include('./kidsloop-frontend/Tiltfile')```

