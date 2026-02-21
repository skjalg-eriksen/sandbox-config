FROM docker.io/library/archlinux:base-20260215.0.490969

# Initialize pacman and update system
RUN pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -Syu --noconfirm

# Install base dev tools
RUN pacman -S --noconfirm \
    sudo \
    neovim \
    tmux \
    git \
    base-devel \
    curl \
    wget \
    ripgrep \
    fd \
    python \
    python-pip \
    less \
    which \
    unzip

# Create dev user
ARG USERNAME=dev
ARG UID=1000

RUN \
    useradd -l -m -u ${UID} -s /bin/bash ${USERNAME} && \
    usermod -aG wheel ${USERNAME} && \
    echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers

USER ${USERNAME}
WORKDIR /workspace

CMD ["/bin/bash"]
