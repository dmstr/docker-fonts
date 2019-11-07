FROM nginx AS build

RUN apt-get update \
    && apt-get install -y \
        curl \
        unzip \
        git \
        build-essential \
        cmake

# build woff2 converter
RUN mkdir -p /sw-build \
    && cd /sw-build \
    && git clone --recursive https://github.com/google/woff2.git \
    && cd woff2 \
    && make clean all \
    && cp woff2_compress /usr/local/bin/

# get webify for woff and eot formats
RUN curl https://github.com/ananthakumaran/webify/releases/download/0.1.7.0/webify-linux-x86_64 -Lo /usr/local/bin/webify \
    && chmod 755 /usr/local/bin/webify

RUN curl https://github.com/google/fonts/archive/master.zip -Lo fonts.zip \
    && unzip fonts.zip \
    && rm fonts.zip

# move all font dirs in one folder
RUN cd /fonts-master && mkdir /google-fonts && mv apache/* ofl/* ufl/* /google-fonts/.

# convert all ttf to woff2
RUN cd /google-fonts \
    && find . -name '*.ttf' -print0 | xargs --null -n 1 woff2_compress

# convert all ttf to woff and eot
RUN cd /google-fonts \
    && find . -name '*.ttf' -print0 | xargs --null -n 1 webify --no-svg


# load ionicons
RUN cd / \
    && curl https://github.com/driftyco/ionicons/archive/v2.0.1.zip -Lo ionicons.zip \
    && unzip ionicons.zip \
    && rm ionicons.zip \
    && mkdir /ionicons \
    && cd /ionicons-2.0.1 \
    && mv fonts css LICENSE /ionicons/.


# copy all font dirs in one basedir

FROM nginx

# copy pre build fonts folder
COPY --from=build /google-fonts /usr/share/nginx/html/google-fonts
COPY --from=build /ionicons /usr/share/nginx/html/ionicons

# Add custom config files to image
COPY image-files/ /
