# Bancolombia Technical Test - Infraestructura Automatizada

## Descripción del Proyecto

Este proyecto implementa una infraestructura completamente automatizada en AWS para una aplicación web simple. Utiliza una combinación de **Terraform**, **AWS CodePipeline**, **AWS CodeBuild**, **Docker**, **Kubernetes**, y **Ansible** para gestionar y desplegar la aplicación web en un entorno de desarrollo y producción.

## Tabla de Contenidos

- [Descripción del Proyecto](#descripción-del-proyecto)
- [Arquitectura](#arquitectura)
- [Pre-requisitos](#pre-requisitos)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Configuración](#configuración)
  - [Variables de Terraform](#variables-de-terraform)
  - [Configuración de Docker](#configuración-de-docker)
  - [Configuración de Kubernetes](#configuración-de-kubernetes)
  - [Ansible](#ansible)
- [Pipeline CI/CD](#pipeline-cicd)
- [Instrucciones de Despliegue](#instrucciones-de-despliegue)
- [Verificación del Despliegue](#verificación-del-despliegue)
- [Resolución de Problemas](#resolución-de-problemas)
- [Notas Adicionales](#notas-adicionales)

## Arquitectura

El proyecto utiliza la siguiente arquitectura:

1. **AWS** para infraestructura en la nube, incluyendo VPC, subredes, Security Groups, EKS (Elastic Kubernetes Service) y S3.
2. **Terraform** para la provisión de infraestructura como código.
3. **AWS CodePipeline** para la gestión del pipeline CI/CD.
4. **AWS CodeBuild** para la construcción de la aplicación.
5. **Docker** para la construcción de la imagen de la aplicación.
6. **Kubernetes** para la orquestación de contenedores.
7. **Ansible** para la gestión de configuración en servidores.

## Pre-requisitos

Antes de comenzar, asegúrate de tener instalado y configurado lo siguiente:

- **AWS CLI** configurado con las credenciales necesarias.
- **Terraform** versión >= 1.0.0.
- **Docker** para construir imágenes localmente.
- **Kubectl** para interactuar con Kubernetes.
- **Ansible** para tareas de gestión de configuración.
- Acceso a **AWS** con permisos adecuados para crear recursos (IAM, EKS, S3, CodePipeline, etc.).

## Estructura del Proyecto

La estructura del proyecto es la siguiente:

bancolombia-technical-test/
├── terraform/
│ ├── main.tf
│ ├── variables.tf
│ ├── outputs.tf
│ └── providers.tf
├── docker/
│ ├── static-website/
│ │ ├── assets/
│ │ ├── index.html
│ │ └── style.css
│ ├── Dockerfile
│ └── docker-compose.yaml
├── kubernetes/
│ ├── deployment.yaml
│ ├── service.yaml
│ └── ingress.yaml
├── ci-cd/
│ ├── pipeline.tf
│ └── buildspec.yaml
├── .env
├── .gitignore
└── README.md

## Configuración

### Variables de Terraform

Las variables necesarias para la infraestructura están definidas en `terraform/variables.tf`. Asegúrate de configurarlas correctamente antes de iniciar:

- `aws_region`
- `vpc_name`
- `eks_cluster_name`
- `eks_instance_types`
- `target_id_1`, `target_id_2`, etc.

### Configuración de Docker

La aplicación web está en el directorio `docker/static-website`. Asegúrate de tener un **Dockerfile** configurado correctamente para construir la imagen de la aplicación. El archivo `docker-compose.yaml` puede ser utilizado para pruebas locales.

### Configuración de Kubernetes

Los archivos de configuración de Kubernetes están en el directorio `kubernetes/`. Estos incluyen:

- `deployment.yaml`: Para la creación de los pods.
- `service.yaml`: Para exponer la aplicación como un servicio.
- `ingress.yaml`: Para la configuración del Ingress en Kubernetes.

### Ansible

El playbook Ansible (`ansible-playbook.yaml`) se encargará de la gestión de configuración de servidores. Esto incluye la instalación de NGINX y la configuración de firewall.

## Pipeline CI/CD

El pipeline está gestionado a través de AWS CodePipeline y CodeBuild. Este pipeline tiene las siguientes etapas:

1. **Source**: Descarga el código fuente desde un bucket S3.
2. **Build**: Construcción de la imagen Docker de la aplicación.
3. **Deploy**: Despliegue de la imagen en Kubernetes y ejecución del playbook Ansible para la configuración de los servidores.

## Instrucciones de Despliegue

### 1. Inicializar Terraform

Navega a la carpeta `ci-cd` y ejecuta los siguientes comandos:

```bash
cd bancolombia-technical-test/ci-cd
terraform init
```
