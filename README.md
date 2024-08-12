# JOT - Log your activites on your Linux Server
![banner](docs/jot-banner.png)

# What is JOT?
Like many things in life, `jot` was born out of a problem. When several people work on a the same Linux server and change files, install services or other things, documentation is very important. However, because this is often forgotten or the changes are very minimal, this is not documented.
JOT automates this procedure by asking the user at login/logout which changes have been made. Each entry is automatically saved in the `.jot` file of the corresponding user and can be easily searched.

# Installation
```console
curl -s https://raw.githubusercontent.com/vozodo/jot/main/install-jot.sh | bash
```

# Commands
| Command | Function |
| -------- | ------- |
| `jot -h` | Prints out the Help message with all possible commands |
| `jot -v` | Make JOT verbose |
| `jot -u` | Pull and Install newest JOT Version from Github |
| `jot -i` | Ask Login Question |
| `jot -o` | Ask Logoff Question |
| `jot` | Run JOT manually |

# Log
A file named `.jot` is created in the home directory for each user who has JOT active. This contains all entries in the register.

The file can be opened very easily:
```console
cat ~/.jot
```

# Credits

- https://betterdev.blog/minimal-safe-bash-script-template/