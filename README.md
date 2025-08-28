# JenkinsTest Overview

This repository contains the setup for a containerized Jenkins environment with supporting build scripts and configurations.

---

## 📁 Directory and File Structure

```
root
├── .clang-format         # Code formatting rules for C/C++ source files.
├── .git/                 # Git metadata directory (version control).
├── .gitignore            # Specifies untracked files to ignore in Git.
├── .githooks/            # Custom Git hooks (e.g., pre-commit checks).
├── ansible/              # Contains Ansible inventory and playbook files.
├── dockerfiles/          # Docker-related definitions and utilities.
├── Jenkinsfile           # Jenkins pipeline configuration for CI/CD.
├── JenkinsHome/          # Persistent storage for Jenkins (plugins, jobs, config).
├── LICENSE               # License for the project.
├── README.md             # Main project documentation (this file).
├── source/               # Project source code and build scripts.
```

---

## Getting Started

### Prerequisites

- Docker
- Docker Compose

### Setup

To start the Jenkins environment:

```sh
docker-compose up --build
```

Access Jenkins at: [http://localhost:8080](http://localhost:8080)

### Git Hooks

Ensure Git uses the custom hooks from `.githooks/` by setting the hook path:

```sh
git config core.hooksPath .githooks
```

---

## Notes

- The `source/` directory contains supporting shell scripts and templates.
- Customize `.clang-format` to enforce code style.
- Review the `Jenkinsfile` to understand or modify CI/CD behavior.

---

## 🧑‍💻 Author

**Rohit Akurdekar**
🔗 [GitHub Profile](https://github.com/RohitAkurdekar)
