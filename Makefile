### -*-Makefile-*- pour préparer le paquetage ulthese
##
## Copyright (C) 2017 Vincent Goulet
##
## 'make class' extrait la classe et les gabarits du fichier dtx.
##
## 'make doc' compile la documentation de la classe et le glossaire.
##
## 'make zip' crée l'archive pour le dépôt dans CTAN.
##
## 'make create-release' crée une nouvelle version dans GitLab.
##
## 'make all' fait les étapes 'class', 'doc' et 'zip'.
##
## Auteur: Vincent Goulet
##
## Ce fichier fait partie du projet ulthese
## https://gitlab.com/vigou3/ulthese


## Nom du paquetage sur CTAN
PACKAGENAME = ulthese

## Nom du dépôt dans GitLab
REPOSURL = https://gitlab.com/vigou3/ulthese

## Liste des fichiers à inclure dans l'archive (outre README.md)
FILES = \
	${PACKAGENAME}.ins \
	${PACKAGENAME}.dtx \
	${PACKAGENAME}.pdf \
	ul_p.eps \
	ul_p.pdf

## Numéro de version et date de publication extraits du fichier
## ulthese.dtx. Le résultat est une chaîne de caractères de la forme
## 'x.y (YYYY-MM-DD)'.
VERSION = $(shell awk -F '[ \[]' '/^  \[.*\]/ \
	    { gsub(/\//, "-", $$4); \
	      printf("%s (%s)", substr($$5, 2), $$4); \
	      exit }' ${PACKAGENAME}.dtx)

## Outils de travail
LATEX = pdflatex
MAKEINDEX = makeindex
CP = cp -p
RM = rm -r

## Dépôt GitLab et authentification
REPOSNAME = $(shell basename ${REPOSURL})
APIURL = https://gitlab.com/api/v4/projects/vigou3%2F${REPOSNAME}
OAUTHTOKEN = $(shell cat ~/.gitlab/token)

## Variable automatique
TAGNAME = v$(word 1,${VERSION})


all : class doc zip

class : ${PACKAGENAME}.dtx
	${LATEX} ${PACKAGENAME}.ins

doc : ${PACKAGENAME}.dtx
	${LATEX} $<
	${MAKEINDEX} -s gglo.ist -o ${PACKAGENAME}.gls ${PACKAGENAME}.glo
	${LATEX} $<

zip : ${FILES} README.md
	if [ -d ${PACKAGENAME} ]; then ${RM} ${PACKAGENAME}; fi
	mkdir ${PACKAGENAME}
	touch ${PACKAGENAME}/README.md && \
	  awk 'state==0 && /^# / { state=1 }; \
	       /^## Author/ { printf("## Version\n\n%s\n\n", "${VERSION}") } \
	       state' README.md >> ${PACKAGENAME}/README.md
	${CP} ${FILES} ${PACKAGENAME}
	zip --filesync -r ${PACKAGENAME}.zip ${PACKAGENAME}
	rm -r ${PACKAGENAME}

upload :
	@echo ----- Uploading archive to GitLab...
	$(eval upload_url_markdown=$(shell curl --form "file=@${PACKAGENAME}.zip" \
	                                        --header "PRIVATE-TOKEN: ${OAUTHTOKEN}"	\
	                                        --silent \
	                                        ${APIURL}/uploads \
	                                   | awk -F '"' '{ print $$12 }'))
	@echo Markdown ready url to file:
	@echo "${upload_url_markdown}"
	@echo ----- Done uploading files

create-release :
	@echo ----- Creating release on GitLab...
	@if [ -n "$(shell git status --porcelain | grep -v '^??')" ]; then \
	    echo "uncommitted changes in repository; not creating release"; exit 2; fi
	@if [ -n "$(shell git log origin/master..HEAD)" ]; then \
	    echo "unpushed commits in repository; pushing to origin"; \
	      git push; fi
	if [ -e relnotes.in ]; then ${RM} relnotes.in; fi
	touch relnotes.in
	awk 'BEGIN { FS = "{"; \
	             v = substr("${TAGNAME}", 2); \
	             printf "{\"tag_name\": \"%s\", \"description\": \"# Version %s\\n", \
		            "${TAGNAME}", "${VERSION}" } \
	     /\\changes/ && substr($$2, 1, length($$2) - 1) == v { \
	         out = $$4; \
	         if ((i = index($$4, "}")) != 0) { \
	             out = substr($$4, 1, i - 1) \
	         } else { \
	             while (i == 0) { \
	                 getline; \
	                 gsub(/^%[ \t]+/, "", $$0); \
	                 i = index($$0, "}"); \
	                 if (i != 0) { \
	                     out = out " " substr($$0, 1, i - 1) \
			 } else { \
			     out = out " " $$0 \
		         } \
		     } \
	         } \
		 printf "- %s\\n", out \
	     } \
	     END { print "\"}" }' \
	     ${PACKAGENAME}.dtx >> relnotes.in
	curl --request POST \
	     --header "PRIVATE-TOKEN: ${OAUTHTOKEN}" \
	     "${APIURL}/repository/tags?tag_name=${TAGNAME}&ref=master"
	curl --data @relnotes.in \
	     --header "PRIVATE-TOKEN: ${OAUTHTOKEN}" \
	     --header "Content-Type: application/json" \
	     ${APIURL}/repository/tags/${TAGNAME}/release
	${RM} relnotes.in
	@echo ----- Done creating the release
