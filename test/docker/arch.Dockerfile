FROM archlinux:latest

RUN pacman -Sy --noconfirm --needed bash git sudo \
  && pacman -Scc --noconfirm

RUN useradd -m -s /bin/bash tester \
  && echo 'tester ALL=(ALL) NOPASSWD:ALL' >/etc/sudoers.d/tester \
  && chmod 0440 /etc/sudoers.d/tester

USER tester
WORKDIR /home/tester/dev-setup
