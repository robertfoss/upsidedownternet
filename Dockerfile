#
# Upsidedownternet Dockerfile
#
# https://github.com/robertfoss/upsidedownternet
#

# Pull base image.
FROM ubuntu

# Install dependencies
RUN \
  apt-get update &&  \
  apt-get install -y \
    hostapd          \
    squid3           \
    udhcpd           \
    python2.7        \
    nginx            \
    iptables         \
    imagemagick

# Set up user groups
RUN usermod -aG www-data proxy
RUN usermod -aG proxy www-data
RUN mkdir -p /tmp/nginx/images
RUN chown -R www-data:www-data /tmp/nginx/images
RUN chmod 775 -R /tmp/nginx/images

# Copy configuration files
ADD rc.local        /etc/rc.local
ADD interfaces      /etc/network/interfaces
ADD hostapd.conf    /opt/hostapd.conf
ADD iptables.rules  /opt/iptables.rules
ADD udhcpd.conf     /opt/udhcpd.conf
ADD nginx.conf      /etc/nginx/sites-available/default
ADD squid.conf      /opt/squid.conf
ADD replace_images  /opt/replace_images
ADD ReseekFile.py   /opt/ReseekFile.py
ADD obey.svg        /opt/obey.svg

# Run on exec
#CMD ["/etc/rc.local"]
