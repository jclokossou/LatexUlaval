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

## Extraction des contenus publiés avec la version et leurs adresses
## URL
ASSETS = $(shell \
  curl --header "PRIVATE-TOKEN: ${OAUTHTOKEN}" \
       --silent \
       ${APIURL}/releases/v${VERSION}/assets/links | \
  sed 's/,/\n/g' | \
  awk 'BEGIN { FS = "\"" } \
       $$2 == "name" { name = $$4; state = 1 } \
       $$2 == "direct_asset_url" && state { printf "%s %s\n", name, $$4; state = 0 }')

all: config commit

config:
	@printf "mise à jour de la configuration...\n"
	@awk 'BEGIN \
	      { \
	          printf "  version: %s\n", "${VERSION}"; \
	          printf "  release date: %s\n", "${DATE}"; \
	          n = split("${ASSETS}", a, " "); \
	          for (i = 1; i <= n; i = i + 2) \
	              printf "  url de %s: %s\n", a[i], a[i + 1] \
	      }'
	@awk 'BEGIN \
	      { \
	          FS = "\""; OFS = "\""; \
	          n = split("${ASSETS}", a, " "); \
	          out = "assets = ["; sep = " "; \
	          for (i = 1; i <= n; i = i + 2) \
	          { \
	              out = out sep \
	                    sprintf("{ name = \"%s\", url = \"%s\" }", \
	                            a[i], a[i + 1]); \
	              sep = ", " \
	          }; \
	          out = out " ]" \
	      } \
	      $$1 ~ /version =/      { $$2 = "${VERSION}" } \
	      $$1 ~ /release_date =/ { $$2 = "${DATE}" } \
	      $$1 ~ /assets =/       { $$0 = "  " out } \
	      1' \
	    ${CONFIG} > tmpfile && \
	  mv tmpfile ${CONFIG}

commit:
	git commit ${CONFIG} -m "Mettre le site à jour pour la version ${VERSION}"
	git push


