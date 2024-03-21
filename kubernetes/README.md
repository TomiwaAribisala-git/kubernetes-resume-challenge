## Connect to EKS Cluster locally with Kubectl 
```sh
aws configure list 
```

```sh
aws eks update-kubeconfig --name ecommerce-app-cluster --region eu-north-1
```

```sh
kubectl cluster-info
```

```sh
kubectl get nodes 
```

```sh
kubectl get pods
```

```sh
kubectl get configmap
```

```sh
kubectl get secret
```

```sh
kubectl get svc
```

```sh
kubectl get pv
```

```sh
kubectl get pvc
```

## Create Secret for Kubernetes to pull Ecommerce Application Docker Image
```sh
kubectl create secret docker-registry regcred docker-service docker.io docker-username tomiwa97 docker-password ************************************
```

## Kubectl Commands
```sh
kubectl apply -f mariadb-secret.yml 
```

```sh
kubectl apply -f storage-class.yml 
```

```sh
kubectl apply -f mariadb-pv1.yml 
``` 

```sh
kubectl apply -f mariadb-pvc.yml 
``` 

```sh
kubectl apply -f mariadb-configmap.yml 
```

```sh
kubectl apply -f mariadb.yml 
```

```sh
kubectl apply -f mariadb-svc.yml 
```

```sh
kubectl apply -f ecom-web-configmap.yml 
```

```sh
kubectl apply -f ecom-web.yml 
```

```sh
kubectl apply -f ecom-web-svc.yml 
```