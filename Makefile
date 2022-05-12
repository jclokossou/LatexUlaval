### -*-Makefile-*- pour préparer la page web de
##                 "Paquetage ulthese"
##
## Copyright (C) 2022 Vincent Goulet
##
## Auteur: Vincent Goulet
##
## Ce fichier fait partie du projet
## "Classe LaTeX pour les thèses et mémoires de l'Université Laval"
## http://gitlab.com/vigou3/ulthese


## Informations de version extraites du document maître
PACKAGENAME = ulthese
VERSION = $(shell \
  git show master:${PACKAGENAME}.dtx | \
  awk -F '[ \[]' '/^  \[.*\]/ \
          { print substr($$5, 2); exit }')
REPOSURL = https://gitlab.com/vigou3/ulthese
TAGNAME = v${VERSION}

## Dépôt GitLab et authentification
REPOSNAME = $(shell basename ${REPOSURL})
APIURL = https://gitlab.com/api/v4/projects/vigou3%2F${REPOSNAME}
OAUTHTOKEN = $(shell cat ~/.gitlab/token)


all: files commit

files:
	awk 'BEGIN { FS = "\""; OFS = "\"" } \
	     /version/ { $$2 = "${VERSION}" } \
	     1' \
	    config.toml > tmpfile && \
	  mv tmpfile config.toml

commit:
	git commit content/_index.md \
	    -m "Updated web page for version ${VERSION}"
	git push


