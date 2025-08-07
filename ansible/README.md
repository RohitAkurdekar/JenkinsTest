# Ansible Playbook: Build Project using Makefile

This Ansible playbook automates the process of building a project using a Makefile and an optional shell script. It is designed to run locally and is compatible with Debian-based systems.


## 🛠️ Prerequisites

- Ansible installed on your system.
- `make` tool available or installable via `apt`.
- Your project source located in `/data/source`.
- `Makefile` located inside `/data/source/Applications/test-bin/`.
- Optional: `build.sh` script in `/data/source`.

## ⚙️ What This Playbook Does

1. **Ensures `make` is installed** (only for Debian-based systems).
2. **Lists files** in `/data/source`.
3. **Builds the project** using the Makefile.
4. **Optionally runs a shell script** to build additional components.

## ▶️ Run the Playbook

        $ ansible-playbook -i inventory build-project.yml

## 📤 Example Output

Here's a snippet of what the output might look like:

```bash

PLAY [Build Project using Makefile] ********************************************

TASK [Gathering Facts] *********************************************************
[WARNING]: Platform linux on host localhost is using the discovered Python
interpreter at /usr/local/bin/python3.12, but future installation of another
Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible-
core/2.18/reference_appendices/interpreter_discovery.html for more information.
ok: [localhost]

TASK [Ensure Make is installed] ************************************************
skipping: [localhost]

TASK [List top-level files] ****************************************************
changed: [localhost]

TASK [debug] *******************************************************************
ok: [localhost] => {
    "output.stdout_lines": [
        "total 16",
        "drwxrw-rw-    1 1000     1000             0 Jul 30 10:38 Applications",
        "-rwxrw-rw-    1 1000     1000           645 Aug  7 17:28 CommonMakefile.mk",
        "drwxrw-rw-    1 1000     1000             0 Jul 30 10:38 Libraries",
        "-rwxrw-rw-    1 1000     1000          1696 Aug  7 05:44 README.md",
        "drwxrw-rw-    1 1000     1000             0 Jul 30 10:38 ThirdPartyLibs",
        "drwxrw-rw-    1 1000     1000             0 Aug  7 17:44 build",
        "-rwxrw-rw-    1 1000     1000          2670 Aug  1 08:16 build.sh",
        "drwxrw-rw-    1 1000     1000          4096 Aug  7 05:44 scripts"
    ]
}

TASK [Build project via Make] **************************************************
changed: [localhost]

TASK [debug] *******************************************************************
ok: [localhost] => {
    "make_output.stdout_lines": [
        "\u001b[1;33m[STAGE]\u001b[0m Build Complete: test-bin"
    ]
}

TASK [Build using script] ******************************************************
changed: [localhost]

TASK [debug] *******************************************************************
ok: [localhost] => {
    "script_output.stdout_lines": [
        "\u001b[1;33mStarting build: \u001b[1;32mbuild/output-20250807_174517\u001b[0m ",
        "\u001b[1;33mBuild complete. Output:\u001b[0m output-20250807.tar.gz"
    ]
}

PLAY RECAP *********************************************************************
localhost                  : ok=7    changed=3    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0


```


---

## 🧑‍💻 Author

**Rohit Akurdekar**
🔗 [GitHub Profile](https://github.com/RohitAkurdekar)
