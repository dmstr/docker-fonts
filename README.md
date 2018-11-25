# docker-fonts

### Google Fonts

This container build a static nginx webserver with all fonts from https://github.com/google/fonts/archive/master.zip 
available in /google-fonts/* directory in DocumentRoot.

Since the master file only provides ttf formats, all existing fonts are also converted to woff, woff2 and eot formats.

Tools used to convert fonts:
- for woff2 https://github.com/google/woff2.git
- for woff, and eot https://github.com/ananthakumaran/webify

To get rid of all build dependencies, we use multi-stage build. 

Nevertheless the finished image has a size of about 2.3GB due to the font files.

To see which fonts are available, the directory index for the directory google-fonts/ is activated in the nginx config.

If you need SSL we recommend to use a proxy like [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy) in front of this container.

## build

Since converting the individual fonts (especially for woff2) takes time, building can take quite a long time.

    docker build . -t docker-nginx-google-fonts

## run

    docker run --rm -p1080:80 -d --name fonts-server docker-nginx-google-fonts
   
## run bash inside container

    docker exec -it fonts-server bash
