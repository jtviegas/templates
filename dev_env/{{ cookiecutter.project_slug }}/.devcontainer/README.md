# NextGenSafety Docker Environment

This project includes a Docker-based development environment for NextGenSafety, which includes necessary tools such as Azure CLI, Databricks CLI, Python, and Java.

[[_TOC_]]

## Requirements

- Docker desktop installed on your local machine (see [here](/documentation/developer/install_docker_desktop.md))
- An Azure account
- Access to the repository
- Visual Studio extensions: Remote-SSH and Dev Containers


Alternatively to docker desktop you can use a DevBox.
- Docker on your DevBox [Docker installation](https://docs.docker.com/engine/install/ubuntu/)
- Run without sudo on devbox [Docker post installation)](https://docs.docker.com/engine/install/linux-postinstall/)

## Installation

Clone the repository like this:

``` bash
git clone git@ssh.dev.azure.com:v3/novonordiskit/SDDS_GxP/NextGenSafety
```

Navigate into the repository and press `CTRL-SHIFT-P`, then select:

``` text
Dev Containers: Rebuild and Reopen in Container
```

You should now be connected to the devcontainer

## Usage

Once the container is started, you will have access to the following tools:

- **Azure CLI**: Used to interact with Azure services
- **Databricks CLI**: Used to interact with the Databricks platform
- **Python**: With `ruff` installed as a linter for code quality control
- **GIT**

## Get git working in the devcontainer

Have a look at [git_in_devcontainer.md](/documentation/developer/git_in_devcontainer.md) for instructions on how to get git working in the devcontainer.
