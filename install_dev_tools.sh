#!/bin/bash

# Debian and Ubuntu

export DEBIAN_FRONTEND=noninteractive

apt-get update -qq

if ! command -v docker &> /dev/null; then
    apt-get install -yqq ca-certificates curl
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update -qq
    apt-get install -yqq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
else
    echo "Docker is already installed."
fi

if command -v python3 &> /dev/null && dpkg --compare-versions "$(python3 -V 2>&1 | awk '{print $2}')" ge "3.9"; then
    echo "Python is already installed."
else
    apt-get install -yqq python3
fi

if ! command -v pip3 &> /dev/null; then
    apt-get install -yqq python3-pip
else
    echo "Pip is already installed."
fi

if ! python3 -m django --version &> /dev/null; then
    python3 -m pip install --upgrade pip
    python3 -m pip install -qq Django
else
    echo "Django is already installed."
fi