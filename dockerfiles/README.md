# Dockerfiles for Jenkins & Ansible Automation

This directory contains configuration and automation files for setting up Jenkins and Ansible using Docker. It's intended for CI/CD experiments and testing automation workflows.

## 📂 Files Overview

---------------------------------------------------------------------------------
| File                 | Description                                            |
|----------------------|--------------------------------------------------------|
| `docker-compose.yml` | Defines multi-container setup for Jenkins and Ansible. |
| `Dockerfile.jenkins` | Dockerfile to build a Jenkins container with plugins.  |
| `Dockerfile.ansible` | Dockerfile to build an Ansible container for playbooks.|
| `makefile`           | Automates build, cleanup, and container management.    |
| `README.md`          | You're reading it.                                     |
---------------------------------------------------------------------------------
---


## 🐳 Quick Start

### 🚀 Using the Makefile
Run the following to execute a specific task:

        $ make <target>


ℹ️ Use `make help` to view all available targets.

-----------------------------------------------------------------------------------
| Targets       | Description                                                      |
|---------------|------------------------------------------------------------------|
|`help`         |Show this help message                                            |
|`status`       |Show status of running containers                                 |
|`status_all`   |Show status of all containers                                     |
|`up`           |Start all services (jenkins + ansible)                            |
|`down`         |Stop all services                                                 |
|`restart`      |Restart all services                                              |
|`start`        |Start a specific service (use like: make start service=jenkins)   |
|`stop`         |Stop a specific service (use like: make stop service=ansible)     |
|`remove`       |Remove a specific service (use like: make remove service=jenkins) |
|`remove_all`   |Remove all services                                               |
|`ansible-bash` |Shell into ansible container                                      |
|`ansible-logs` |Tail logs from Ansible container                                  |
|`ansible`      |Run Ansible playbook                                              |
|`jenkins-bash` |Shell into jenkins container                                      |
|`jenkins-logs` |Tail logs from Jenkins container                                  |
-----------------------------------------------------------------------------------

## 🧑‍💻 Author

**Rohit Akurdekar**
🔗 [GitHub Profile](https://github.com/RohitAkurdekar)
