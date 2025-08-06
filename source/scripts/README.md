# Project Maintenance Scripts

This directory contains utility scripts for maintaining project structure, aligning and fixing Makefiles, and automating versioning.

---

## 📁 Directory Structure

source/scripts/ <br>
├── `align_makefiles.sh` # Aligns variable ordering and structure across Makefiles <br>
├── `create_structure.sh` # Creates standard directory and file structure for modules <br>
├── `fix_makefile_indentation.sh` # Normalizes indentation in all Makefiles <br>
├── `makefile.template` # Template for new Makefiles <br>
└── `update_version.sh` # Updates version information across components <br>


---

## 🔧 Script Overview

### 🛠️ `align_makefiles.sh`

- **Purpose**: Standardizes formatting and ordering of variables and sections across all project Makefiles.
- **Usage**:

      $ ./align_makefiles.sh

- Effect: Helps maintain consistency and readability across multiple Makefiles in the repo.

### 🏗️ `create_structure.sh`

- Purpose: Automatically generates a standard directory structure for a new module or component.

    Typical Output:

        new-module/
        ├── include/
        ├── src/
        ├── Makefile
        └── README.md

- Usage:

        $ ./create_structure.sh <module-name>

### 🧹 fix_makefile_indentation.sh

- Purpose: Fixes inconsistent tab/spaces in Makefiles to ensure compatibility with make.

- Usage:

        $ ./fix_makefile_indentation.sh

- Details: Replaces leading spaces with tabs where necessary and ensures clean formatting.

### 📄 makefile.template

- Purpose: Template used by create_structure.sh or manually when starting a new component.
- Includes:
    - Standard build rules
    - Variable declarations (SRC_DIR, BUILD_DIR, etc.)
    - Clean and install targets

### 🔄 update_version.sh

- Purpose: Automatically updates version numbers in version files or headers across the project.
- Usage:

        $ ./update_version.sh <new-version>

- Example:

        $ ./update_version.sh 2.1.0

### 💡 Usage Tips

Give all scripts executable permission once:

        $ chmod +x *.sh
---

## 🧪 Testing

These scripts are meant for local development use. Ensure they are tested in a safe or version-controlled environment before applying them in CI or production builds.

---

## 🧑‍💻 Author

**Rohit Akurdekar**
🔗 [GitHub Profile](https://github.com/RohitAkurdekar)
