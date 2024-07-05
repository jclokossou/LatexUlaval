### -*-Makefile-*- pour mettre à jour la page web de ulthese
##
## Copyright (C) 2019-2024 Vincent Goulet pour la Faculté des études
## supérieures et postdoctorales de l'Université Laval
##
## Auteur: Vincent Goulet
##
## Ce fichier fait partie du projet "Classe LaTeX pour les thèses et
## mémoires de l'Université Laval"
## https://gitlab.com/vigou3/ulthese

## Noms des contenus
ARCHIVE = ulthese.zip
ARCHIVENOTEX = ulthese-installation-projet.zip
ASSETS = ${ARCHIVE} ${ARCHIVENOTEX}

## Fichier de configuration
CONFIG = hugo.toml

## Dépôt GitLab et authentification
REPOSNAME = $(basename ${ARCHIVE})
APIURL = https://gitlab.com/api/v4/projects/vigou3%2F${REPOSNAME}
OAUTHTOKEN = $(shell cat ~/.gitlab/token)

## Extraction du numéro et de la date de la plus récente version
## directement du dépôt
VERSIONFULL = $(shell \
  curl --header "PRIVATE-TOKEN: ${OAUTHTOKEN}" \
       --silent \
       "${APIURL}/releases" | \
  grep -o '{"name":"[^"]*"' | \
  head -n 1 | \
  cut -d \" -f 4 | \
  tr -d \(\))
VERSION = $(word 2,${VERSIONFULL})
DATE = $(word 3,${VERSIONFULL})

## Extraction des adresses URL des contenus publiés avec la version
ASSETS_URL = $(shell \
  curl --header "PRIVATE-TOKEN: ${OAUTHTOKEN}" \
       --silent \
       ${APIURL}/releases/v${VERSION}/assets/links | \
  sed 's/,/\n/g' | \
  awk 'BEGIN { FS = "\""; split("${ASSETS}", assets, " ")} \
       $$2 == "name" { for (i in assets) if ($$4 == assets[i]) { state = 1; break } } \
       $$2 == "direct_asset_url" && state { print $$4; state = 0 }')

all: config commit

config:
	@printf "updating the configuration...\n"
	@awk 'BEGIN \
	      { \
	          split("${ASSETS}", assets, " "); \
	          split("${ASSETS_URL}", url, " "); \
	          for (i in assets) \
	              printf "  url to %s: %s\n", assets[i], url[i] \
	      }'
	@awk 'BEGIN \
	      { \
	          FS = "\""; OFS = "\""; \
	          split("${ASSETS}", assets, " "); \
	          split("${ASSETS_URL}", url, " "); \
	          for (i in assets) a[assets[i]] = url[i] \
	      } \
	      $$1 ~ /version/      { $$2 = "${VERSION}" } \
	      $$1 ~ /release_date/ { $$2 = "${DATE}" } \
	      $$1 ~ /archive_name/ { $$2 = "${ARCHIVE}" } \
	      $$1 ~ /archive_url/  { $$2 = a["${ARCHIVE}"] } \
	      $$1 ~ /archivenotex_name/ { $$2 = "${ARCHIVENOTEX}" } \
	      $$1 ~ /archivenotex_url/  { $$2 = a["${ARCHIVENOTEX}"] } \
	      1' \
	    ${CONFIG} > tmpfile && \
	  mv tmpfile ${CONFIG}

commit:
	git commit ${CONFIG} -m "Mettre le site à jour pour la version ${VERSION}"
	git push


