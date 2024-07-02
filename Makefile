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
ARCHIVE = ulthese-installation-projet.zip

## Fichier de configuration
CONFIG = hugo.toml

## Dépôt GitLab et authentification
REPOSNAME = ulthese
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

## Extraction de l'adresse URL du contenu publié avec la version
ASSETS = $(shell \
  curl --header "PRIVATE-TOKEN: ${OAUTHTOKEN}" \
       --silent \
       ${APIURL}/releases/v${VERSION}/assets/links | \
  sed 's/,/\n/g' | \
  awk 'BEGIN { FS = "\"" } \
       /^"name"/ { file = $$4 } \
       /^"direct_asset_url"/ { print file, $$4 }')
ARCHIVE_ID = $(shell echo "${ASSETS}" | \
  awk '{ for (i = 1; i <= NF; i++) if ($$i = "${ARCHIVE}") { print $$(i + 1); exit } }')

all: config commit

config:
	@printf "mise à jour de la configuration...\n"
	@printf "  numéro de version: %s\n" "${VERSION}"
	@printf "  date de publication: %s\n" "${DATE}"
	@printf "  nom de l'archive: %s\n" "${ARCHIVE}"
	@printf "  adresse URL de l'archive: %s\n" "${ARCHIVE_ID}"
	@awk 'BEGIN { FS = "\""; OFS = "\"" } \
	     /version/    { $$2 = "${VERSION}" } \
	     /release_date/ { $$2 = "${DATE}" } \
	     /archive_name/ { $$2 = "${ARCHIVE}" } \
	     /archive_id/ { $$2 = "${ARCHIVE_ID}" } \
	     1' \
	    ${CONFIG} > tmpfile && \
	  mv tmpfile ${CONFIG}

commit:
	git commit ${CONFIG} -m "Mettre le site à jour pour la version ${VERSION}"
	git push


