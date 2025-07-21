FROM ubuntu:22.04

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages for Nix installation and update CA certificates
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    sudo \
    ca-certificates \
    xz-utils \
    && update-ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Prepare Nix store and group to support single-user install
RUN mkdir -m 0755 /nix \
 && chown root:root /nix \
 && groupadd -g 30000 nixbld

# Set environment so Nix is on PATH
ENV USER=root
ENV HOME=/root
ENV PATH=/root/.nix-profile/bin:/root/.nix-profile/sbin:$PATH

# Install Nix
RUN curl -L https://nixos.org/nix/install | sh -s -- --daemon

# Configure Nix to run in unprivileged mode (no nixbld group needed)
RUN mkdir -p /etc/nix && echo "build-users-group =" >> /etc/nix/nix.conf

# Add Nix channels for Nixpkgs and Home Manager
# Source the Nix profile before running nix-channel commands
RUN . /root/.nix-profile/etc/profile.d/nix.sh && \
    nix-channel --add https://nixos.org/channels/nixos-25.05 nixpkgs && \
    nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager && \
    nix-channel --update

# Install home-manager for the root user
RUN . /root/.nix-profile/etc/profile.d/nix.sh && \
    nix-shell '<home-manager>' -A install

# Set the working directory
WORKDIR /root

# Default command when the container starts
CMD ["bash"]
