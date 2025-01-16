# Etapa 1: Builder para construir a aplicação Rails
FROM ruby:2.5.1-slim

# Instalar dependências para compilar o Passenger
RUN sed -i '/stretch-updates/d' /etc/apt/sources.list && \
  sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|' /etc/apt/sources.list && \
  sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|' /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  build-essential \
  gnupg \
  gnupg2 \
  dirmngr \
  apt-transport-https \
  ca-certificates \
  libpq-dev \
  imagemagick \
  libmagickwand-dev \
  wget \
  file \
  curl \
  zlib1g-dev \
  libcurl4-openssl-dev \
  nginx \
  nano \
  cron \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
  #gcc \
  #make \

RUN wget http://archive.ubuntu.com/ubuntu/pool/main/libj/libjpeg-turbo/libjpeg-turbo8_2.0.3-0ubuntu1_amd64.deb && dpkg -i libjpeg-turbo8_2.0.3-0ubuntu1_amd64.deb

# Instalar Node.js e Yarn
SHELL ["/bin/bash", "-c"]
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash && \
  source /root/.nvm/nvm.sh && \
  nvm install 14 && \
  npm install --global yarn && \
  ln -s /root/.nvm/versions/node/v14.*/bin/yarn /usr/local/bin/yarn && \
  ln -s /root/.nvm/versions/node/v14.*/bin/node /usr/local/bin/node

# Adicionar o repositório do Phusion Passenger
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 && \
  sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger stretch main > /etc/apt/sources.list.d/passenger.list' && \
  apt-get update && \
  apt-get install -y --no-install-recommends libnginx-mod-http-passenger passenger && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*


# docker build -t mariojorge/docker-nginx-ruby-2.5.1 .
# docker push mariojorge/docker-nginx-ruby-2.5.1