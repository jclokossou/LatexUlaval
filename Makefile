### -*-Makefile-*- pour préparer le paquetage ulthese
##
## Copyright (C) 2017-2024 Faculté des études supérieures et
## postdoctorales
##
## 'make class' extrait la classe et les gabarits du fichier dtx.
##
## 'make doc' compile la documentation de la classe et le glossaire.
##
## 'make changes' extrait la liste des notes de version (vers la
## sortie standard).
##
## 'make zip' crée l'archive pour le dépôt dans CTAN.
##
## 'make release' crée une nouvelle version dans GitLab, téléverse le
## fichier .zip et modifie les liens de la page web..
##
## 'make all' fait les étapes 'class' et 'doc'.
##
## Auteur: Vincent Goulet
##
## Ce fichier fait partie du projet ulthese
## https://gitlab.com/vigou3/ulthese


## Nom du paquetage sur CTAN
PACKAGENAME = ulthese
MAIN = ${PACKAGENAME}.dtx
README = README.md
ARCHIVE = ${PACKAGENAME}.zip
ARCHIVENOTEX = ${PACKAGENAME}-installation-projet.zip

## Nom du dépôt dans GitLab
REPOSURL = https://gitlab.com/vigou3/ulthese

## Liste des fichiers à inclure dans l'archive (outre README.md)
SOURCES = ${MAIN:.dtx=.ins} ${MAIN}
DOC = ${MAIN:.dtx=.pdf}
IMAGES = ul_p.eps ul_p.pdf

## Liste des fichiers créés lors de l'installation
CLASS = ${MAIN:.dtx=.cls} 
TEMPLATES = $(shell awk -F '[{}]' \
	            '$$1 ~ /\\file/ && $$2 ~ /\.tex$$/ { print $$2 }' \
	            ${MAIN:.dtx=.ins})

## Numéro de version et date de publication extraits du fichier
## ulthese.dtx. Le résultat est une chaîne de caractères de la forme
## 'x.y (YYYY-MM-DD)'.
VERSION = $(shell awk -F '[ \[]' '/^  \[.*\]/ \
	    { gsub(/\//, "-", $$4); \
	      printf("%s (%s)", substr($$5, 2), $$4); \
	      exit }' ${PACKAGENAME}.dtx)

## «Fonction» d'extraction des entrées de l'historique des versions
## correspondant à VERSION.
define get_changes
	awk '/\\changes\{$(word 1,${1})\}/ \
	     { \
	         sub(/^%[ \t]+\\changes\{.*\}\{.*\}\{/, "", $$0); \
	         out = $$0; \
	         if (match($$0, ".*\}$$")) { \
	             out = substr($$0, RSTART, RLENGTH - 1) \
	         } else { \
	             while (RSTART == 0) { \
	                 getline; \
	                 sub(/^%[ \t]+/, "", $$0); \
	                 if (match($$0, ".*\}$$")) { \
	                     out = out " " substr($$0, RSTART, RLENGTH - 1) \
	                 } else { \
	                     out = out " " $$0 \
	                 } \
	             } \
	         } \
	         gsub(/ \^\^A/, "", out); \
	         printf "- %s\n", out \
	     }' "${2}"
endef

## Outils de travail
LATEX = latex -halt-on-error
XELATEX = xelatex -halt-on-error
MAKEINDEX = makeindex
CP = cp -p
RM = rm -r
MD := mkdir -p
ZIP = zip --filesync -r -9

## Dossier temporaire pour construire l'archive
BUILDDIR := builddir

## Dépôt GitLab et authentification
REPOSNAME = $(shell basename ${REPOSURL})
APIURL = https://gitlab.com/api/v4/projects/vigou3%2F${REPOSNAME}
OAUTHTOKEN = $(shell cat ~/.gitlab/token)

## Variable automatique
TAGNAME = v$(word 1,${VERSION})


all: class doc

${CLASS} ${TEMPLATES}: ${SOURCES}
	${LATEX} ${MAIN:.dtx=.ins}

${DOC}: ${MAIN}
	${XELATEX} $<
	${MAKEINDEX} -s gglo.ist -o ${MAIN:.dtx=.gls} ${MAIN:.dtx=.glo}
	${XELATEX} $<
	${XELATEX} $<

.PHONY: class
class: ${CLASS}

.PHONY: doc
doc: ${DOC}

.PHONY: changes
changes:
	@$(call get_changes,${VERSION},${MAIN})

.PHONY: release
release: zip check-status upload create-release publish

## CTAN exige un répertoire $PACKAGENAME à la racine de l'archive
.PHONY: zip
zip : ${SOURCES} ${CLASS} ${TEMPLATES} ${DOC} ${IMAGES} ${README}
	if [ -d ${BUILDDIR} ]; then ${RM} ${BUILDDIR}; fi
	${MD} ${BUILDDIR}/${PACKAGENAME} \
	      ${BUILDDIR}/${PACKAGENAME}.tds/doc/latex/${PACKAGENAME} \
	      ${BUILDDIR}/${PACKAGENAME}.tds/source/latex/${PACKAGENAME} \
	      ${BUILDDIR}/${PACKAGENAME}.tds/tex/latex/${PACKAGENAME}
	touch ${BUILDDIR}/${PACKAGENAME}/${README} && \
	  awk '(state == 0) && /^# / { state = 1 }; \
	       /^## Author/ { printf("## Version\n\n%s\n\n", "${VERSION}") } \
	       state' ${README} >> ${BUILDDIR}/${PACKAGENAME}/${README}
	${CP} ${DOC} ${SOURCES} ${IMAGES} ${BUILDDIR}/${PACKAGENAME}
	${CP} ${BUILDDIR}/${PACKAGENAME}/${README} ${DOC} ${TEMPLATES} \
	      ${BUILDDIR}/${PACKAGENAME}.tds/doc/latex/${PACKAGENAME}
	${CP} ${SOURCES} \
	      ${BUILDDIR}/${PACKAGENAME}.tds/source/latex/${PACKAGENAME}
	${CP} ${CLASS} ${IMAGES} \
	      ${BUILDDIR}/${PACKAGENAME}.tds/tex/latex/${PACKAGENAME}
	cd ${BUILDDIR}/${PACKAGENAME}.tds && \
	  ${ZIP} ../${ARCHIVE:.zip=.tds.zip} *
	cd ${BUILDDIR} && \
	  ${ZIP} ../${ARCHIVE} ${PACKAGENAME} ${ARCHIVE:.zip=.tds.zip}
	cd ${BUILDDIR}/${PACKAGENAME} && \
	   ${LATEX} ${PACKAGENAME}.ins && \
	   ${ZIP} ../../${ARCHIVENOTEX} * \
	          -x ${SOURCES}  ${ARCHIVE:.zip=.tds.zip} \*.log
	${RM} ${BUILDDIR}

.PHONY: check-status
check-status:
	@{ \
	    printf "%s" "vérification de l'état du dépôt local... "; \
	    branch=$$(git branch --list | grep ^* | cut -d " " -f 2-); \
	    if [ "$${branch}" != "master"  ] && [ "$${branch}" != "main" ]; \
	    then \
	        printf "\n%s\n" "! pas sur la branche main"; exit 2; \
	    fi; \
	    if [ -n "$$(git status --porcelain | grep -v '^??')" ]; \
	    then \
	        printf "\n%s\n" "! changements non archivés dans le dépôt"; exit 2; \
	    fi; \
	    if [ -n "$$(git log origin/master..HEAD | head -n1)" ]; \
	    then \
	        printf "\n%s\n" "changements non publiés dans le dépôt; publication dans origin"; \
	        git push; \
	    else \
	        printf "%s\n" "ok"; \
	    fi; \
	}

.PHONY: create-release
create-release:
	@{ \
	    printf "%s" "vérification que la version existe déjà... "; \
	    http_code=$$(curl -I "${APIURL}/releases/${TAGNAME}" 2>/dev/null \
	                     | head -n1 | cut -d " " -f2) ; \
	    if [ "$${http_code}" = "200" ]; \
	    then \
	        printf "%s\n" "oui"; \
	        printf "%s\n" "-> utilisation de la version actuelle"; \
	    else \
	        printf "%s\n" "non"; \
	        printf "%s" "création d'une version dans GitLab... "; \
	        name="Version ${VERSION}"; \
	        desc="$$($(call get_changes,${VERSION},${MAIN}) | \
	            sed -E -e 's/\\cs\{([^\}]*)\}/`\\\1`/g' \
	                   -e 's/\\texttt\{([^\}]*)\}/`\1`/g' \
	                   -e 's/\\textbf\{([^\}]*)\}/**\1**/g' \
	                   -e 's/\\emph\{([^\}]*)\}/*\1*/g' \
	                   -e 's/\{?\\(La)?TeX\}?/\1TeX/g')"; \
	        curl --request POST \
	             --header "PRIVATE-TOKEN: ${OAUTHTOKEN}" \
	             --output /dev/null --silent \
	             "${APIURL}/repository/tags?tag_name=${TAGNAME}&ref=master" && \
	        curl --request POST \
	             --header "PRIVATE-TOKEN: ${OAUTHTOKEN}" \
	             --data tag_name="${TAGNAME}" \
	             --data name="$${name}" \
	             --data description="$${desc}" \
	             --output /dev/null --silent \
	             ${APIURL}/releases; \
	        printf "%s\n" "ok"; \
	    fi; \
	}

.PHONY: upload
upload:
	@printf "%s\n" "téléversement de l'archive vers le registre..."
	for f in ${ARCHIVE} ${ARCHIVENOTEX} ${TEMPLATES}; \
	do \
	    curl --upload-file $${f} \
	         --header "PRIVATE-TOKEN: ${OAUTHTOKEN}" \
	         --silent \
	         "${APIURL}/packages/generic/${REPOSNAME}/${TAGNAME}/$${f}"; \
	done
	@printf "\n%s\n" "ok"

.PHONY: create-link
create-link:
	@printf "%s\n" "ajout du lien dans la description de la version..."
	$(eval PKG_ID=$(shell curl --header "PRIVATE-TOKEN: ${OAUTHTOKEN}" \
	                           --silent \
	                           "${APIURL}/packages" \
	                      | grep -o -E '\{[^{]*"version":"${TAGNAME}"[^}]*}' \
	                      | grep -o '"id":[0-9]*' | cut -d: -f 2))
	@for f in ${ARCHIVE} ${ARCHIVENOTEX}; \
	do \
	    file_id=$$(curl --header "PRIVATE-TOKEN: ${OAUTHTOKEN}" \
	                    --silent \
	                    "${APIURL}/packages/${PKG_ID}/package_files" \
	               | grep -o -E "\{[^{]*\"file_name\":\"$${f}\"[^}]*}" \
	               | grep -o '"id":[0-9]*' | cut -d: -f 2) && \
	    url="${REPOSURL:/=}/-/package_files/$${file_id}/download" && \
	    printf "  url to %s: %s\n" "$${f}" "$${url}" && \
	    curl --request POST \
	         --header "PRIVATE-TOKEN: ${OAUTHTOKEN}" \
	         --data name="$${f}" \
	         --data url="$${url}" \
	         --data link_type="package" \
	         --output /dev/null --silent \
	         "${APIURL}/releases/${TAGNAME}/assets/links"; \
	done
	@printf "%s\n" "ok"

.PHONY: check-url
check-url: ${MAIN}
	@printf "%s\n" "vérification des adresses URL dans les fichiers source"
	$(eval url=$(shell grep -E -o -h 'https?:\/\/[^./]+(?:\.[^./]+)+(?:\/[^ ]*)?' $? \
		   | cut -d \} -f 1 \
		   | cut -d ] -f 1 \
		   | cut -d '"' -f 1 \
		   | sort | uniq))
	@for u in ${url}; do \
	    printf "%s... " "$$u"; \
	    if curl --output /dev/null --silent --head --fail --max-time 5 "$$u"; then \
	        printf "%s\n" "ok"; \
	    else \
		printf "%s\n" "invalide ou ne répond pas"; \
	    fi; \
	done

.PHONY: publish
publish:
	@echo ----- Publishing the web page...
	git checkout pages && \
	  ${MAKE} && \
	  git checkout master
	@echo ----- Done publishing
