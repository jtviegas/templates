FROM debian:bookworm

ARG PYTHON_VERSION=3.9

COPY .devcontainer/zscaler-root-ca.crt /usr/local/share/ca-certificates/zscaler-root-ca.crt

RUN apt-get update && \
    apt-get install -y ca-certificates && \
    update-ca-certificates
    
# Install dependencies
RUN apt update && apt install -y \
    curl \
    git \
    unzip \
    python3 python3-venv \
    bash-completion \
    openjdk-17-jdk \
    sudo \
    locales \
    locales-all \
    wget bzip2

# Clean up
RUN rm -rf /var/lib/apt/lists/*

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Databricks CLI
RUN curl -fsSL https://raw.githubusercontent.com/databricks/setup-cli/main/install.sh | sh

# Set Java home and update path
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

# Add user
ARG USERNAME=vscode
RUN useradd -ms /bin/bash $USERNAME \
    && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && adduser $USERNAME sudo

USER $USERNAME
WORKDIR /home/$USERNAME

# Installer poetry
# RUN curl -sSL https://install.python-poetry.org | python3 -

# Configure poetry and activate environment
# ENV POETRY_NO_INTERACTION=1 \
#    POETRY_VIRTUALENVS_IN_PROJECT=true \
#    POETRY_VIRTUALENVS_CREATE=true \
#    POETRY_CACHE_DIR=/tmp/poetry_cache

# RUN echo 'source $(poetry env info --path)/bin/activate' >> ~/.bashrc

# Add Poetry to PATH
ENV PATH="/home/$USERNAME/venv/bin:$PATH"
ENV REQUESTS_CA_BUNDLE="/etc/ssl/certs/ca-certificates.crt"
ENV SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"

# Copy project files
# COPY pyproject.toml ./

# Set environment variables
ENV DATABRICKS_HOST="https://adb-1820730458762836.16.azuredatabricks.net/"

# Set alias
RUN echo "alias azlogin='az login --allow-no-subscriptions'" >> ~/.bashrc
