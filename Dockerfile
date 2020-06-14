FROM ubuntu

COPY LICENSE README.md /

COPY ./contrib/semver-tool ./contrib/semver-tool
RUN install ./contrib/semver-tool/src/semver /usr/local/bin
RUN apt-get update && apt install -y git git-lfs
COPY entrypoint.sh /entrypoint.sh


ENTRYPOINT ["/entrypoint.sh"]
