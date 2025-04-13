ARG BUILD_FROM
FROM $BUILD_FROM

LABEL io.hass.version="1.6" io.hass.type="addon" io.hass.arch="aarch64|amd64"

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install base packages
RUN apt update \
    && apt install -y --no-install-recommends \
        sudo \
        locales \
        cups \
        cups-filters \
        avahi-daemon \
        libnss-mdns \
        dbus \
        colord \
        printer-driver-all-enforce \
        printer-driver-all \
        printer-driver-splix \
        printer-driver-brlaser \
        printer-driver-gutenprint \
        openprinting-ppds \
        hpijs-ppds \
        hp-ppd  \
        hplip \
        printer-driver-foo2zjs \
        printer-driver-hpcups \
        printer-driver-escpr \
        cups-pdf \
        gnupg2 \
        lsb-release \
        nano \
        samba \
        bash-completion \
        procps \
        whois \
        file \
        imagemagick \
        poppler-utils \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/*

# Add Canon cnijfilter2 driver
RUN cd /tmp \
  && if [ "$(arch)" = 'x86_64' ]; then ARCH="amd64"; else ARCH="arm64"; fi \
  && curl https://gdlp01.c-wss.com/gds/0/0100012300/02/cnijfilter2-6.80-1-deb.tar.gz -o cnijfilter2.tar.gz \
  && tar -xvf ./cnijfilter2.tar.gz cnijfilter2-6.80-1-deb/packages/cnijfilter2_6.80-1_${ARCH}.deb \
  && mv cnijfilter2-6.80-1-deb/packages/cnijfilter2_6.80-1_${ARCH}.deb cnijfilter2_6.80-1.deb \
  && apt install ./cnijfilter2_6.80-1.deb

# Copy rootfs first
COPY rootfs /

# Add user and disable sudo password checking
RUN useradd \
    --groups=sudo,lp,lpadmin \
    --create-home \
    --home-dir=/home/print \
    --shell=/bin/bash \
    --password=$(mkpasswd print) \
    print \
    && sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers

EXPOSE 631

# Compile the Zebra driver
RUN mkdir -p /usr/share/cups/model/zebra \
    && ppdc -d /usr/share/cups/model/zebra /usr/share/cups/drv/zebra-zd621d.drv

# Create log directory and set permissions
RUN mkdir -p /var/log/cups \
    && touch /var/log/cups/zebra_filter.log \
    && chown print:lp /var/log/cups/zebra_filter.log \
    && chmod 660 /var/log/cups/zebra_filter.log

# Set permissions for CUPS configuration
RUN chown -R print:lp /etc/cups \
    && chmod -R 755 /etc/cups

RUN chmod a+x /run.sh

CMD ["/run.sh"]