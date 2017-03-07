## Nom du paquetage sur CTAN
PACKAGENAME = ulthese

## Liste des fichiers à inclure dans l'archive (outre README)
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
	latex ulthese.ins

doc : ulthese.dtx ulthese.gls
	${LATEX} ulthese.dtx
	${MAKEINDEX} -s gglo.ist -o ulthese.gls ulthese.glo
	${LATEX} ulthese.dtx

zip : ${FILES}
	if [ -d ${PACKAGENAME} ]; then ${RM} ${PACKAGENAME}; fi
	mkdir ${PACKAGENAME}
	cp ${FILES} ${PACKAGENAME}
	sed -e 's/<VERSION>/${VERSION}/' README.in > ${PACKAGENAME}/README
	zip --filesync -r ${PACKAGENAME}.zip ${PACKAGENAME}
	rm -r ${PACKAGENAME}
