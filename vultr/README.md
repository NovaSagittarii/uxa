# Terraform for setting up Kubernetes on Vultr

## Tools to install first

- [kubectl](https://kubernetes.io/docs/reference/kubectl/)
- [helm](https://helm.sh/docs/intro/install/)
- [Terraform](https://developer.hashicorp.com/terraform/install/)

## Vultr Setup

1. Register an account on [Vultr](https://www.vultr.com/).
2. Get API key for account, copy [.env.template](.env.template) in to `.env` and update the key.
3. Load into environment
   ```sh
   export $(grep -v '^#' .env | xargs)
   ```
4. Apply terraform
   ```sh
   terraform init
   terraform apply
   terraform output -raw kubeconfig | base64 -d > kubeconfig.yaml
   export KUBECONFIG=$PWD/kubeconfig.yaml
   ```
5. Destroy afterwards
   ```sh
   terraform destroy
   ```
