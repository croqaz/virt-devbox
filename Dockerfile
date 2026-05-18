FROM ubuntu:noble

ENV LANG en_US.utf8
ENV LC_ALL en_US.utf8
ENV TZ Europe/London
RUN echo "Europe/London" > /etc/timezone

# Regular apps
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    automake \
    bubblewrap \
    build-essential \
    bzip2 \
    ca-certificates \
    clang \
    cmake \
    coreutils \
    curl \
    direnv \
    fd-find \
    git \
    gnupg \
    gzip \
    less \
    libtool \
    locales \
    lsb-release \
    make \
    openssh-client \
    patch \
    pinentry-tty \
    pkg-config \
    ripgrep \
    socat \
    tar \
    tzdata \
    ufw \
    unzip \
    wget \
    xxd \
    xz-utils \
    zip \
    zsh

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

# DEV libraries
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    libbz2-dev \
    libffi-dev \
    libfreetype6-dev \
    libgdbm-dev \
    libjpeg-dev \
    liblzma-dev \
    libmagic-dev \
    libncurses5-dev \
    libnss3-dev \
    libopenblas-dev \
    libopencv-dev \
    libopenmpi-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libtool \
    libxml2-dev \
    libxmlsec1-dev \
    libxslt1-dev \
    zlib1g-dev

RUN DEBIAN_FRONTEND=noninteractive apt remove python3 --yes && \
    rm -rf /usr/lib/python3

RUN apt autoclean && \
    apt autoremove --yes

# make sure to mount PWD like: -v `pwd`:/root/PWD
WORKDIR "/root/PWD"

ADD scripts /tmp/scripts
RUN chmod -R +rx /tmp/scripts

RUN /tmp/scripts/install-neovim.sh

RUN rm -rf /var/lib/apt/lists/*

CMD ["zsh"]
