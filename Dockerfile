# Build the frontend
FROM node:20-bookworm-slim AS build-frontend

RUN apt-get update && apt-get install -y \
    git \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*i

RUN cd /opt && \
  git clone --depth=1 https://github.com/omgbebebe/reticulum-meshchat && \
  cd reticulum-meshchat && \
  npm install --omit=dev && \
  npm run build-frontend

FROM debian:13

LABEL maintainer="omgbebebe@gmail.com"

RUN apt-get update && apt-get install -y \
    iproute2 \
    net-tools \
    git \
    python3 \
    python3-pip \
    python3-venv \
    nginx \
    curl \
    vim-nox \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*i

# install Reticulum
RUN mkdir /opt/rns && cd /opt/rns && python3 -m venv .venv && . .venv/bin/activate && pip3 install rns lxmf

# install rrcd 
RUN cd /opt && \
  git clone --depth=1 https://github.com/kc1awv/rrcd.git && \
  cd rrcd && \
  python3 -m venv .venv && . .venv/bin/activate && \
  python -m pip install lxmf && \
  python -m pip install . && \
  python -m pip install -e .

# install rrc webUI
RUN cd /opt && \
  git clone --depth=1 https://github.com/kc1awv/rrc-web.git && \
  cd rrc-web && \
  python3 -m venv .venv && . .venv/bin/activate && \
  python -m pip install lxmf && \
  python -m pip install .

# install Reticulum MeshChat
RUN cd /opt && \
  git clone --depth=1 https://github.com/omgbebebe/reticulum-meshchat && \
  cd reticulum-meshchat && \
  python3 -m venv .venv && . .venv/bin/activate && \
  pip install -r requirements.txt
COPY --from=build-frontend /opt/reticulum-meshchat/public /opt/reticulum-meshchat/public

COPY start_rnsd.sh /usr/local/bin/
COPY start_meshchat.sh /usr/local/bin/
COPY start_rrcd.sh /usr/local/bin/
COPY start_rrc-web.sh /usr/local/bin/
CMD ["/bin/bash"]
#ENTRYPOINT ["/usr/local/bin/start_rnsd.sh"]
#ENTRYPOINT ["/usr/local/bin/start_meshchat.sh"]
