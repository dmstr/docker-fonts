FROM nginx

RUN apt-get update \
 && apt-get install -y \
        curl \
        unzip

RUN curl https://github.com/google/fonts/archive/master.zip -Lo fonts.zip \
 && unzip fonts.zip \
 && rm fonts.zip

RUN ln -s /fonts-master /usr/share/nginx/html/google-fonts