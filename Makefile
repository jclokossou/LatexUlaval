### -*-Makefile-*- pour préparer la page web de
##                 "Paquetage ulthese"
##
## Copyright (C) 2019 Vincent Goulet
##
## Auteur: Vincent Goulet
##
## Ce fichier fait partie du projet
## "Classe LaTeX pour les thèses et mémoires de l'Université Laval"
## http://gitlab.com/vigou3/ulthese


## Numéro de version extrait du document maître
PACKAGENAME = ulthese
VERSION = $(shell git show master:${PACKAGENAME}.dtx | \
	          awk -F '[ \[]' '/^  \[.*\]/ \
                      { print substr($$5, 2); exit }')
REPOSURL = https://gitlab.com/vigou3/ulthese

## Dépôt GitLab et authentification
REPOSNAME = $(shell basename ${REPOSURL})
APIURL = https://gitlab.com/api/v4/projects/vigou3%2F${REPOSNAME}
OAUTHTOKEN = $(shell cat ~/.gitlab/token)

## Variables automatiques
TAGNAME = v${VERSION}


all: files commit

files:
	$(eval url=$(subst /,\/,$(patsubst %/,%,${REPOSURL})))
	$(eval file_id=$(shell curl --header "PRIVATE-TOKEN: ${OAUTHTOKEN}" \
	                             --silent \
	                             ${APIURL}/releases/${TAGNAME}/assets/links \
	                        | grep -o "/uploads/[a-z0-9]*/" \
	                        | cut -d/ -f3))
	cd content && \
	  awk 'BEGIN { FS = "/"; OFS = "/" } \
	       /^## Version/ { print; getline; print; getline; \
	                       gsub(/[0-9]+\.[0-9]+([0-9]*[a-z]*)?/, "${VERSION}") } \
	       1' \
	      _index.md > tmpfile && \
	  mv tmpfile _index.md

commit:
	git commit content/_index.md \
	    -m "Updated web page for version ${VERSION}"
	git push


