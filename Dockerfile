FROM ubuntu:22.04

USER root
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl wget sudo ttyd qemu-system-x86 qemu-kvm \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 1000 user && echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER user
WORKDIR /home/user

COPY --chown=user:user start.sh /home/user/start.sh
RUN chmod +x /home/user/start.sh

ENTRYPOINT ["/home/user/start.sh"]
