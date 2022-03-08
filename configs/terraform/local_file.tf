resource "null_resource" "eks_init" {
  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${var.cluster_name}"
  }
}

resource "local_file" "db_config_map" {
  content  = <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: db-config-map
  namespace: default
data:
  DB_HOST: "${module.database.this_db_instance_address}"
  DB_NAME: "${module.database.this_db_instance_name}"
  DB_USER: "${module.database.this_db_instance_username}"
  DB_PASSWORD: "${module.database.this_db_instance_password}"
  EOF
  filename = "${path.module}./kubernetes/db-config-map.yaml"
}

resource "local_file" "deployment" {
filename = "${path.module}./kubernetes/deployment.yaml"

content  = <<EOF
apiVersion: v1
kind: Service
metadata:
  name: wordpress
spec:
  ports:
    - port: 80
  selector:
    tier: web
  type: LoadBalancer
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
  labels:
    tier: web
spec:
  replicas: 3
  selector:
    matchLabels:
      tier: web
  template:
    metadata:
      labels:
        tier: web
    spec:
      containers:
      - image: wordpress:latest
        name: wordpress
        ports:
        - containerPort: 80 
        env:
        - name: WORDPRESS_DB_HOST
          value: "${module.database.this_db_instance_address}"
        - name: WORDPRESS_DB_PASSWORD
          value: "${module.database.this_db_instance_password}"
        - name: WORDPRESS_DB_USER
          value: "${module.database.this_db_instance_username}"
        - name: WORDPRESS_DB_NAME
          value:  "${module.database.this_db_instance_name}"
EOF
}

resource "null_resource" "elb_hostname" {
  provisioner "local-exec" {
    command = "kubectl get services wordpress -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' > cloudfront/elb_hostname"
  }
}
