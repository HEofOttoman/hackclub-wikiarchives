FROM mediawiki:1.46

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*



# RUN git clone --depth 1 https://gerrit.wikimedia.org/r/mediawiki/extensions/MobileFrontend \
RUN git clone https://gerrit.wikimedia.org/r/mediawiki/extensions/MobileFrontend --branch REL1_46 \
    /var/www/html/extensions/MobileFrontend
# git checkout REL1_46 \

# RUN git clone --depth 1 -b REL1_46 https://wikimedia.org extensions/RSS; \
# RUN git clone --depth 1 -b REL1_46 https://wikimedia.org extensions/PluggableAuth; \
# RUN git clone --depth 1 -b REL1_46 https://wikimedia.org extensions/OpenIDConnect; \

