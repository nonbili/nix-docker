FROM debian:buster-slim

RUN apt-get update
RUN apt-get install -y curl xz-utils git rsync

RUN useradd circleci -m

# create /nix directory
RUN mkdir -m 0755 /nix && chown circleci /nix

USER circleci

ENV USER=circleci

RUN mkdir -p ~/.config/nix && echo 'sandbox = false' > ~/.config/nix/nix.conf

RUN curl https://nixos.org/nix/install | sh

RUN ~/.nix-profile/bin/nix-env -iA cachix -f https://cachix.org/api/v1/install

RUN ~/.nix-profile/bin/nix-env -i nodejs yarn

RUN . ~/.nix-profile/etc/profile.d/nix.sh && ~/.nix-profile/bin/nix-env -f https://github.com/nonbili/nonbili-nix-deps/archive/4fc735c10a8eee4a5d044164621651b89d0d6782.tar.gz -iA purs spago zephyr
