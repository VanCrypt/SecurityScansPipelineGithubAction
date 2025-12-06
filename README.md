# 🔐 Security Check Pipeline – Overview

This repository provides a complete **security-focused CI/CD pipeline** designed to automatically build, test, and scan a containerized application.
It is intended as a simple, reusable template for anyone who wants to **secure their code, Docker images, and infrastructure configuration** using GitHub Actions.

# 🚀 What This Repository Does

Whenever you push code, commit or run the workflow, GitHub Actions automatically runs a set of security jobs:

## 🧱 **1. Build a Docker Application**

The repository contains a minimal example application (`main.py`) and a `Dockerfile`.

The workflow:

```bash
docker build -t myapp:latest .
docker run --rm myapp:latest
```
You can replace `main.py` and the Dockerfile with your own app.

✔ Builds a Docker image using your application
✔ Runs a smoke test by executing the container
✔ Cleans up automatically after execution

## 🛡️ **2. File System Scan (Trivy FS)**

Trivy scans the project’s source code for:

* sensitive files or secrets
* vulnerable dependencies
* known misconfigurations

## 🐳 **3. Docker Image Scan (Trivy Image)**

After building the container, Trivy analyzes the **Docker image itself**, detecting:

* OS-level vulnerabilities
* application library CVEs
* insecure system packages
* misconfigurations inside the image layers

## 🧰 **4. Infrastructure-as-Code Scan (Checkov)**

Checkov analyzes configuration and IaC files, including:

* Dockerfile
* GitHub Actions workflows
* Terraform / Kubernetes manifests (if added)

## 📦 **5. Dependency Vulnerability Scan (OWASP Dependency-Check)**

Dependency-Check:

* downloads the latest vulnerability database (NVD)
* scans your project files for known dependencies
* identifies CVEs affecting those dependencies
* generates an HTML security report

The report is uploaded as an artifact for review.

For OWASP Dependency-Check, it is recommended to provide a free NIST API key to significantly speed up vulnerability database downloads (up to 5× faster). You can obtain one at: https://nvd.nist.gov/developers/request-an-api-key and store it as `NVD_API_KEY` in your repository’s GitHub Actions secrets.

# 🧩 **How to Use This Repository**

1. Clone or copy this repository
2. Replace the example `main.py` and `Dockerfile` with your own application
3. Update `requirements.txt` with your own.
4. Push your changes

The pipeline automatically:

* builds your application
* scans the code and image
* checks infrastructure configuration
* scans dependencies for known vulnerabilities
* outputs downloadable reports

➡️ **No extra configuration required.**

