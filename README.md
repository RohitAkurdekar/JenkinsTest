# JenkinsTest Overview

This repository contains the setup for a containerized Jenkins environment with supporting build scripts and configurations.

---

## Directory and File Structure

```
root
├── .clang-format             # Code formatting rules for C/C++ source files.
├── .githooks/                # Custom Git hooks (e.g., pre-commit).
├── .gitignore                # Specifies intentionally untracked files to ignore.
├── .git/                     # Git repository metadata.
├── docker-compose.yml        # Defines Docker services and configurations.
├── Dockerfile                # Docker image definition for the Jenkins or build environment.
├── Jenkinsfile               # Jenkins pipeline definition for CI/CD.
├── JenkinsHome/              # Persistent volume for Jenkins home (plugins, jobs, config, etc.).
├── LICENSE                   # Project licensing information.
├── README.md                 # Project documentation (you are here).
└── source/                   # Source code and related scripts.
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
