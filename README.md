# Home Assistant CUPS Addon
With AirPrint + label printing rasterizing for a Zebra ZD621D.

Forked from Grzegorz Zajac's [here]https://github.com/zajac-grzegorz/homeassistant-addon-cups-airprint 

CUPS addon with working Avahi in reflector mode 

Tested with Home Assistant version **2025.2.3**

CUPS administrator login: **print**, password: **print** (can be changed in the Dockerfile)

Configuration data is stored in **/addon_configs/<slug>_cups** folder

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fzajac-grzegorz%2Fhomeassistant-addon-cups-airprint)


# Motivation

1) I don't want to advertise my printer from a personal computer, therfore Home Assistant is a good place to run CUPS for AirPrint advertising
2) Label printing to OSX is difficult to avoid dithering which destroys barcodes. I want to be able to print labels from my phone because I often print from selling apps downloaded there. I found a good repo [here](https://github.com/john-stephens/zebra-mac-label-automator) which uses imagemagick to rasterize shipping labels, but this only works for printing from desktop.

Therefore, I hope to combine these two