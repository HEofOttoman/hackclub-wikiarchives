# FROM node:20-slim AS skin-builder
# WORKDIR /build

# Install git to download the skin repository
# RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Clone the Citizen repository (or specify a specific release tag/branch using -b)
## https://mwcitizen.skin/guide/installation
# RUN git clone https://github.com/StarCitizenTools/mediawiki-skins-Citizen.git skins/Citizen --depth 1 \

FROM mediawiki:1.46

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/StarCitizenTools/mediawiki-skins-Citizen.git \
    /var/www/html/skins/Citizen

# RUN git clone --depth 1 https://gerrit.wikimedia.org/r/mediawiki/extensions/MobileFrontend \
RUN git clone https://gerrit.wikimedia.org/r/mediawiki/extensions/MobileFrontend --branch REL1_46 \
    /var/www/html/extensions/MobileFrontend

RUN git clone --branch REL1_46 https://gerrit.wikimedia.org/r/mediawiki/extensions/ExternalData \
    /var/www/html/extensions/ExternalData

# needed for the specific trailing path pattern eg. extensions/OpenIDConnect
WORKDIR /var/www/html/extensions 

# \ = multiline command 
RUN git clone --depth 1 -b REL1_46 https://gerrit.wikimedia.org/r/mediawiki/extensions/RSS extensions/RSS
RUN git clone --depth 1 -b REL1_46 https://gerrit.wikimedia.org/r/mediawiki/extensions/PluggableAuth extensions/PluggableAuth
RUN git clone --depth 1 -b REL1_46 https://gerrit.wikimedia.org/r/mediawiki/extensions/OpenIDConnect extensions/OpenIDConnect

    # git checkout REL1_46 \
