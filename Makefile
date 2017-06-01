### -*-Makefile-*- pour préparer le paquetage ulthese
##
## Copyright (C) 2017 Vincent Goulet
##
## 'make class' extrait la classe et les gabarits du fichier dtx;
## 'make doc' compile la documentation de la classe et le glossaire;
## 'make zip' crée l'archive pour le dépôt dans CTAN;
## 'make create-release' crée une nouvelle version dans GitHub;
## 'make all' fait les étapes 'class', 'doc' et 'zip'.
##
## Auteur: Vincent Goulet
##
## Ce fichier fait partie du projet formation-latex-ul
## http://github.com/vigou3/formation-latex-ul


## Nom du paquetage sur CTAN
PACKAGENAME = ulthese

## Liste des fichiers à inclure dans l'archive (outre README.md)
FILES=${PACKAGENAME}.ins ${PACKAGENAME}.dtx ${PACKAGENAME}.pdf ul_p.eps ul_p.pdf

## Numéro de version et date de publication extraits du fichier
## ulthese.dtx. Le résultat est une chaîne de caractères de la forme
## 'x.y (YYYY-MM-DD)'.
VERSION = $(shell awk -F '[ \[]' '/^  \[.*\]/ \
	    { gsub(/\//, "-", $$4); \
	      printf("%s (%s)", substr($$5, 2), $$4); \
	      exit }' ${PACKAGENAME}.dtx)

# Outils de travail
LATEX = pdflatex
MAKEINDEX = makeindex
RM = rm -r

## Dépôt GitHub et authentification
REPOSURL = https://api.github.com/repos/vigou3/ulthese
OAUTHTOKEN = $(shell cat ~/.github/token)


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
	cp ${FILES} ${PACKAGENAME}
	zip --filesync -r ${PACKAGENAME}.zip ${PACKAGENAME}
	rm -r ${PACKAGENAME}

create-release :
	@echo ----- Creating release on GitHub...
	if [ -e relnotes.in ]; then rm relnotes.in; fi
	touch relnotes.in
	#git commit -a -m "Version ${VERSION}" && git push
	awk 'BEGIN { FS = "{"; \
	             split("${VERSION}", v, " "); \
	             printf "{\"tag_name\": \"v%s\", \"name\": \"Version %s\", \"body\": \"", \
		            v[1], "${VERSION}" } \
	     /\\changes/ && substr($$2, 1, length($$2) - 1) == v[1] { \
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
	     END { print "\", \"draft\": false, \"prerelease\": false}" }' \
	     ${PACKAGENAME}.dtx >> relnotes.in
	curl --data @relnotes.in ${REPOSURL}/releases?access_token=${OAUTHTOKEN}
	rm relnotes.in
	@echo ----- Done creating the release

