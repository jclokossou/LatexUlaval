### -*-Makefile-*- pour préparer le paquetage ulthese
##
## Copyright (C) 2017 Vincent Goulet
##
## 'make class' extrait la classe et les gabarits du fichier dtx;
## 'make doc' compile la documentation de la classe et le glossaire;
## 'make zip' crée l'archive pour le dépôt dans CTAN;
## 'make all' fait toutes les étapes ci-dessus.
##
## Auteur: Vincent Goulet
##
## Ce fichier fait partie du projet formation-latex-ul
## http://github.com/vigou3/formation-latex-ul


## Nom du paquetage sur CTAN
PACKAGENAME = ulthese

## Liste des fichiers à inclure dans l'archive (outre README.md)
FILES=ulthese.ins ulthese.dtx ulthese.pdf ul_p.eps ul_p.pdf

## Numéro de version et date de publication extraits du fichier
## ulthese.dtx. Le résultat est une chaîne de caractères de la forme
## 'x.y (YYYY-MM-DD)'.
VERSION = $(shell awk -F '[ \[]' '/^  \[.*\]/ \
	    { gsub(/\//, "-", $$4); \
	      printf("%s (%s)", substr($$5, 2), $$4); \
	      exit }' ulthese.dtx)

# Outils de travail
LATEX = pdflatex
MAKEINDEX = makeindex
RM = rm -r

all : class doc zip

class : ulthese.dtx
	${LATEX} ulthese.ins

doc : ulthese.dtx ulthese.gls
	${LATEX} ulthese.dtx
	${MAKEINDEX} -s gglo.ist -o ulthese.gls ulthese.glo
	${LATEX} ulthese.dtx

zip : ${FILES} README-HEADER.in README.md
	if [ -d ${PACKAGENAME} ]; then ${RM} ${PACKAGENAME}; fi
	mkdir ${PACKAGENAME}
	touch ${PACKAGENAME}/README.md && \
	  awk 'state==0 && /^# / { state=1 }; \
	       /^## Author/ { printf("## Version\n\n%s\n\n", "${VERSION}") } \
	       state' README.md >> ${PACKAGENAME}/README.md
	cp ${FILES} ${PACKAGENAME}
	zip --filesync -r ${PACKAGENAME}.zip ${PACKAGENAME}
	rm -r ${PACKAGENAME}
