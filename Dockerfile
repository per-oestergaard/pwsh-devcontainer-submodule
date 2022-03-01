# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.194.3/containers/alpine/.devcontainer/base.Dockerfile

# [Choice] Alpine version: 3.14, 3.13, 3.12, 3.11
ARG VARIANT="3.13"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-alpine-${VARIANT}

ARG USERNAME=vscode
ARG USER_UID=1000
# ARG USER_GID=$USER_UID

# Add sudo for the non-admin user

RUN apk add --no-cache sudo \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
  && chmod 0440 /etc/sudoers.d/$USERNAME

# Ensure docker includes sudo

COPY bashrc /home/$USERNAME/.bashrc

# ** [Optional] Uncomment this section to install additional packages. **
RUN apk update

RUN apk add --no-cache docker-cli

# install the requirements
RUN apk add --no-cache \
  ca-certificates \
  less \
  ncurses-terminfo-base \
  krb5-libs \
  libgcc \
  libintl \
  libssl1.1 \
  libstdc++ \
  tzdata \
  userspace-rcu \
  zlib \
  icu-libs \
  curl

RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache \
  lttng-ust

# Download the powershell '.tar.gz' archive
RUN curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.1.4/powershell-7.1.4-linux-alpine-x64.tar.gz -o /tmp/powershell.tar.gz

# Create the target folder where powershell will be placed
RUN mkdir -p /opt/microsoft/powershell/7

# Expand powershell to the target folder
RUN tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7

# Set execute permissions
RUN chmod +x /opt/microsoft/powershell/7/pwsh

# Create the symbolic link that points to pwsh
RUN ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh

# Start PowerShell
# pwsh