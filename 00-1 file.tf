resource "random_string" "file" {
  length           = 3
  upper            = false
  lower            = false
  numeric          = true
  special          = false
}

resource "aws_s3_bucket" "app" {
  bucket = "app-${random_string.file.result}"
  force_destroy = true
}

resource "aws_s3_object" "buildspec" {
  bucket = aws_s3_bucket.app.id
  key    = "/buildspec.yaml"
  source = "./src/buildspec.yaml"
  etag   = filemd5("./src/buildspec.yaml")
  content_type = "application/vnd.yaml"
}

resource "aws_s3_object" "blue_py" {
  bucket = aws_s3_bucket.app.id
  key    = "/blue/blue.py"
  source = "./src/blue/blue.py"
  etag   = filemd5("./src/blue/blue.py")
}

resource "aws_s3_object" "blue_index_html" {
  bucket = aws_s3_bucket.app.id
  key    = "/blue/templates/index.html"
  source = "./src/blue/templates/index.html"
  etag   = filemd5("./src/blue/templates/index.html")
}

resource "aws_s3_object" "blue_html" {
  bucket = aws_s3_bucket.app.id
  key    = "/blue/templates/blue.html"
  source = "./src/blue/templates/blue.html"
  etag   = filemd5("./src/blue/templates/blue.html")
}

resource "aws_s3_object" "blue_Dockerfile" {
  bucket = aws_s3_bucket.app.id
  key    = "/blue/Dockerfile"
  source = "./src/blue/Dockerfile"
  etag   = filemd5("./src/blue/Dockerfile")
}

resource "aws_s3_object" "green_py" {
  bucket = aws_s3_bucket.app.id
  key    = "/green/green.py"
  source = "./src/green/green.py"
  etag   = filemd5("./src/green/green.py")
}

resource "aws_s3_object" "green_index_html" {
  bucket = aws_s3_bucket.app.id
  key    = "/green/templates/index.html"
  source = "./src/green/templates/index.html"
  etag   = filemd5("./src/green/templates/index.html")
}

resource "aws_s3_object" "green_html" {
  bucket = aws_s3_bucket.app.id
  key    = "/green/templates/green.html"
  source = "./src/green/templates/green.html"
  etag   = filemd5("./src/green/templates/green.html")
}

resource "aws_s3_object" "green_Dockerfile" {
  bucket = aws_s3_bucket.app.id
  key    = "/green/Dockerfile"
  source = "./src/green/Dockerfile"
  etag   = filemd5("./src/green/Dockerfile")
}

resource "aws_s3_object" "cluster" {
  bucket        = aws_s3_bucket.app.id
  key           = "/k8s-yaml/eks/cluster.yaml"
  source        = "./src/k8s-yaml/eks/cluster.yaml"
  etag          = filemd5("./src/k8s-yaml/eks/cluster.yaml")
}

resource "aws_s3_object" "blue_deployment" {
  bucket        = aws_s3_bucket.app.id
  key           = "/k8s-yaml/yaml/blue/deployment.yaml"
  source        = "./src/k8s-yaml/yaml/blue/deployment.yaml"
  etag          = filemd5("./src/k8s-yaml/yaml/blue/deployment.yaml")
}

resource "aws_s3_object" "blue_service" {
  bucket        = aws_s3_bucket.app.id
  key           = "/k8s-yaml/yaml/blue/service.yaml"
  source        = "./src/k8s-yaml/yaml/blue/service.yaml"
  etag          = filemd5("./src/k8s-yaml/yaml/blue/service.yaml")
}

resource "aws_s3_object" "green_deployment" {
  bucket        = aws_s3_bucket.app.id
  key           = "/k8s-yaml/yaml/green/deployment.yaml"
  source        = "./src/k8s-yaml/yaml/green/deployment.yaml"
  etag          = filemd5("./src/k8s-yaml/yaml/green/deployment.yaml")
}

resource "aws_s3_object" "green_service" {
  bucket        = aws_s3_bucket.app.id
  key           = "/k8s-yaml/yaml/green/service.yaml"
  source        = "./src/k8s-yaml/yaml/green/service.yaml"
  etag          = filemd5("./src/k8s-yaml/yaml/green/service.yaml")
}

resource "aws_s3_object" "ingress" {
  bucket        = aws_s3_bucket.app.id
  key           = "/k8s-yaml/yaml/ingress.yaml"
  source        = "./src/k8s-yaml/yaml/ingress.yaml"
  etag          = filemd5("./src/k8s-yaml/yaml/ingress.yaml")
}

resource "aws_s3_object" "pv" {
  bucket        = aws_s3_bucket.app.id
  key           = "/k8s-yaml/yaml/pv.yaml"
  source        = "./src/k8s-yaml/yaml/pv.yaml"
  etag          = filemd5("./src/k8s-yaml/yaml/pv.yaml")
}

resource "aws_s3_object" "pvc" {
  bucket        = aws_s3_bucket.app.id
  key           = "/k8s-yaml/yaml/pvc.yaml"
  source        = "./src/k8s-yaml/yaml/pvc.yaml"
  etag          = filemd5("./src/k8s-yaml/yaml/pvc.yaml")
}

resource "aws_s3_object" "sc" {
  bucket        = aws_s3_bucket.app.id
  key           = "/k8s-yaml/yaml/sc.yaml"
  source        = "./src/k8s-yaml/yaml/sc.yaml"
  etag          = filemd5("./src/k8s-yaml/yaml/sc.yaml")
}