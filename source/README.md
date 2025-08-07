# Project Overview

This repository provides a modular C++ project structure with libraries, applications, build tools, and scripts.

---

## 📁 Directory Structure

```
source/
├── Applications/ # C++ applications (e.g., test-bin)
│
├── Libraries/ # Reusable C++ libraries
│
├── ThirdPartyLibs/ # External libraries
│
├── scripts/ # Utility scripts
│
├── build.sh # Entry point to build the entire project
├── CommonMakefile.mk # Shared Makefile logic
├── build/ # Output binaries, libraries, and archives
│
└── README.md # You're reading it
```

---

## 📦 Components

### 🔧 Applications/test-bin
- Contains sample application `test-bin`
- `testMain.cpp`: Application entry point
- `testMain.h`: Application header

### 📚 Libraries/libakutils
- Shared library for utility functions
- `akJsonUtils.cpp` and `akJsonUtils.h` manage JSON utility functionality
- Compiles into `libakutils.so`

### 🧰 ThirdPartyLibs
- External dependency: `nlohmann-json` library header (`json.hpp`)

### 🛠️ Scripts
- Automation tools to manage builds and structure:
  - `create_structure.sh`: Initializes folder structure
  - `update_version.sh`: Inserts version string
  - `align_makefiles.sh`, `fix_makefile_indentation.sh`: Maintains consistency in Makefiles

### 🏗️ build/
- Build artifacts and outputs
- Timestamps in output folder names indicate the build date/time

---

## 🚀 Build Instructions

```bash
cd source/
chmod +x build.sh
./build.sh
```

Artifacts are generated in the `build/output-<timestamp>/` directory.

---

## 🧑‍💻 Author

**Rohit Akurdekar**
🔗 [GitHub Profile](https://github.com/RohitAkurdekar)
