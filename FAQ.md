# Information générale sur LaTeX

## Je ne connais pas LaTeX. De quoi s'agit-il?

LaTeX est un système de composition de documents basé sur le système TeX développé par Donald Knuth. Le X final des noms étant en fait la lettre grecque khi (&chi;), on prononce ceux-ci «latek» et «tek».

Lorsque l'on rédige un document avec LaTeX, on se concentre sur son contenu et sa structure logique (chapitres, sections, paragraphes, etc.) plutôt que sur son apparence. Cette dernière, c'est le système LaTeX qui s'en charge lors d'une phase de compilation du document. C'est tout le contraire de travailler avec un logiciel de traitement de texte, où l'on est sans cesse distrait par la mise en page et le formatage de son document.

Les premiers pas en LaTeX sont un peu plus difficiles qu'avec un logiciel de traitement de texte WYSIWYG (tel que Word), mais la préparation d'un seul court document suffit généralement pour saisir les principes les plus importants. De plus, la qualité visuelle du document produit est incommensurable avec ce que produisent les traitements de texte courants.

Pour de plus amples informations sur le système LaTeX, commencez par les sites suivants:

* la [page Wikipedia](http://fr.wikipedia.org/wiki/LaTeX) (en français);

* le site officiel du [projet LaTeX](http://www.latex-project.org) (en anglais);

* le site du [TeX User Group](http://tug.org) (en anglais);

* la [http://www.tex.ac.uk/cgi-bin/texfaq2html](foire aux questions) du groupe d'utilisateurs de TeX du Royaume-Uni (''UK TeX User Group''), une indispensable source d'information (en anglais).

## Super, où puis-je me procurer le logiciel?

TeX et LaTeX sont des logiciels libres et gratuits. On se procure le système LaTeX sous forme d'une ''distribution'' comprenant les principaux programmes, une sélection de paquetages et d'extensions, des polices de caractères, divers outils additionnels, etc. Il y a en a pour plusieurs centaines de mégaoctets. Les distributions les plus populaires aujourd'hui sont:

* [TeX Live](http://tug.org/texlive) pour les systèmes Unix, Linux, OS&nbsp;X et Windows. Il s'agit d'une distribution très exhaustive disponible en une seule saveur: la totale. Pratique car une fois la distribution installée, on a rarement à télécharger autre chose;

* [MacTeX](http://tug.org/mactex), une version de TeX Live plus spécifiquement adaptée aux systèmes OS&nbsp;X;

* [MiKTeX](http://miktex.org) pour les systèmes Windows. Bien intégrée à Windows, c'est une distribution conviviale à installer et à administrer. Comme on débute avec une installation de base plus restreinte, le système doit parfois ajouter des extensions.

De manière générale, tout ce qui a trait à TeX et LaTeX se trouve dans le site de [CTAN](http://ctan.tug.org).

## Où dois-je taper mon texte?

<!-- Page existe dans WikiThèse sur ce sujet.  -->
On entre le code source d'un document LaTeX dans un [éditeur de texte](http://fr.wikipedia.org/wiki/Éditeur_de_texte). L'édition sera beaucoup plus agréble si l'éditeur est conçu pour LaTeX ou comporte un mode spécial pour ce type de documents; Wikipedia en propose [une sélection](http://fr.wikipedia.org/wiki/LaTeX#Logiciels).

## Qui peut m'aider à apprendre LaTeX?

La Faculté des études supérieures et postdoctorales n'offre pas de soutien pour l'apprentissage et l'utilisation de LaTeX. Le nouvel utilisateur peut toutefois compter sur une multitude de ressources imprimées et en ligne; consultez la page [Latex:documentation] pour une courte liste.

# Installation de la classe '''ulthese'''

## Je n'ai jamais installé d'extension LaTeX moi-même. Par où commencer?

Premièrement, téléchargez la classe '''ulthese''' depuis [CTAN](http://ctan.tug.org/tex-archive/macros/latex/contrib/ulthese) sous forme d'une archive `ulthese.zip`.

Deuxièmement, déterminez un dossier de travail sur votre système dans lequel vous placerez les fichiers relatifs à votre mémoire ou à votre thèse. C'est dans ce dossier que nous recommandons d'extraire le fichier `ulthese.zip`.

'''''Attention''''': sous Windows Vista/7, il ne suffit pas de cliquer sur l'archive pour en extraire les fichiers. Il faut par la suite cliquer sur «Extraire les fichiers» dans la barre de titre de la fenêtre de visualisation du contenu de l'archive.

Le fichier `README` extrait de l'archive ainsi que la documentation en format PDF renferment des instructions d'installation. La Faculté des études supérieures et postdoctorales a également créé une [!!!URL!!! capsule d'information] sur l'installation de la classe.

Une fois le fichier `ulthese.cls` et les fichiers `gabarit-*.tex` créés, la classe est prête à être utilisée pour composer un document. Mais avant de commencer, assurez-vous de d'abord lire la documentation de la classe.

## Comment compiler le fichier `ulthese.ins` depuis l'invite de commande?

Sous Windows Vista/7, on trouve l'Invite de commande dans le groupe de programmes «Accessoires» du menu Démarrer. On peut aussi la lancer rapidement en entrant `cmd.exe` dans la boîte de recherche du menu Démarrer.

Sous OS&nbsp;X, l'application Terminal se trouve dans le sous-dossier «Utilitaires» du dossier «Applications». On peut aussi la lancer en tapant `Terminal` dans le Spotlight.

Une fois l'invite de commande lancée, vous devez vous déplacer dans le dossier de travail de votre mémoire ou thèse. Pour ce faire, utilisez la commande `cd` suivie du chemin d'accès complet. Par exemple:

```~$ cd Documents/memoire```

Une fois dans le dossier de travail, vous pouvez lancer l'exécution du script `ulthese.ins` avec la commande

```~$ latex ulthese.ins```

## Je compile le fichier `ulthese.ins` depuis mon éditeur de texte et je n'obtiens que des erreurs. Que se passe-t-il?

Le fichier `ulthese.ins` ne peut être compilé qu'en utilisant les commandes `tex`, `latex`, `pdftex` ou `pdflatex`. Certains éditeurs de texte et environnements de rédaction LaTeX utilisent par défaut une autre suite de commandes. Choisir plutôt l'une des options précitées.

## Qu'est-ce qui se passe au juste lors de l'installation de la classe?

Le code de la classe, des gabarits et de la documentation est entièrement contenu dans le fichier `ulthese.dtx`.

Le fichier `ulthese.ins` est un script qui permet d'en extraire le code de la classe (le fichier `ulthese.cls`) et tous les gabarits (les fichiers `gabarit-*.tex`). Ce script a ceci de particulier qu'on l'exécute avec les commandes `tex`, `latex` ou `pdflatex`.

La documentation de la classe est fournie avec celle-ci en format PDF. On peut néanmoins la recréer en compilant le fichier `ulthese.dtx` comme un fichier usuel.

# Utilisation de la classe et des gabarits

## Les caractères accentués s'affichent bizarrement dans mon éditeur de texte (`dÃ©commenter`; `franÃ§ais`)

Dès que l'on rédige un document contenant du français (ou à peu près toute langue autre que l'anglais), il faut déterminer un système pour représenter et sauvegarder les caractères accentués dans l'ordinateur. Ce système est appelé l'''encodage''.

Les gabarits livrés avec la classe sont encodés en UTF-8 de la norme [Unicode](http://fr.wikipedia.org/wiki/Unicode). L'UTF-8 est l'encodage par défaut des systèmes OS&nbsp;X et Linux. La norme Unicode n'est toutefois pas supportée uniformément par Windows et les éditeurs de texte sous cette plateforme. Vérifiez d'abord que votre éditeur supporte la norme Unicode ou l'UTF-8.

Si vous ne pouvez ou ne voulez pas travailler en UTF-8, pas de souci! Seuls les commentaires dans les gabarits comportent des accents, alors vous pouvez les supprimer ou simplement ignorer les caractères bizarres. Cependant, vous devrez faire une modification au gabarit utilisé: remplacer la ligne
```\usepackage[utf8]{inputenc}```
par
```\usepackage[latin1]{inputenc}```
ou
```\usepackage[latin9]{inputenc}```
ou
```\usepackage[cp1252]{inputenc}```
selon l'encodage que vous aurez choisi.

## Les commandes `\it`, `\bf`, `\sf`, `\rm` et `\cak` génèrent des erreurs lors de la compilation

Ces commandes désuètes [ne sont plus recommandées](http://www.tex.ac.uk/cgi-bin/texfaq2html?label=2letterfontcmd) depuis le milieu des années 1990. La classe '''memoir''', sur laquelle '''ulthese''' est basée, va une étape plus loi et désactive ces commandes.

Utilisez la version LaTeX2e des commandes: `\textit`, `\textbf`, etc.

## Comment éviter l'avertissement `Package frenchb.ldf Warning` lors de la compilation?

L'avertissement

```
Package frenchb.ldf Warning: The definition of \@makecaption has been changed,
(frenchb.ldf) frenchb will NOT customise it;
(frenchb.ldf) reported on input line 759.
```

apparaît systématiquement lors l'utilisation de la classe avec l'option `français` de '''babel'''. C'est un avertissement bénin et sans conséquence dont on ne semble pas pouvoir se débarrasser.

## Que faire si mon document est entièrement rédigé en français (ou en anglais)?

La Faculté des études supérieures et postdoctorales exige que tout mémoire ou thèse comporte un résumé en français. Par conséquent, à moins d'exceptions, la seule manière de n'utiliser qu'une seule langue dans un document, c'est de le régiger entièrement en français et de ne pas inclure de résumé en anglais.

Dans de tels cas, on peut déclarer seulement la langue `francais` lors du chargement de la classe '''ulthese'''. Il faut alors supprimer du gabarit la ligne

```
\include{abstract}
```

prévue pour un résumé en anglais.

## Mon titre est très long. Comment éviter que la page titre ne décale sur la deuxième page?

Les décalages peuvent se produire si le titre ou le sous-titre du mémoire ou de la thèse dépasse une ligne. Dans ce cas, il est nécessaire d'utiliser des commandes spéciales de la classe pour éviter que tout le texte de la page titre ne soit décalé vers le bas.

Consultez la documentation de la classe dans la section des commandes de la page titre, vous y trouverez des exemples concrets pour solutionner le problème.

## Je n'arrive pas à visionner mon fichier DVI

Symptôme: en consultant votre fichier DVI, vous obtenez des erreurs du
type

```
Error: /undefined in H.S
Operand stack:
  --nostringval--   PermitFileReading   --nostringval--
```

Cause: le paquetage '''hyperref''' utilisé par la classe pour gérer les hyperliens dans le document doit insérer des commandes spéciales dans le fichier DVI.

* Remède simple: compiler directement en format PDF avec la commande `pdflatex`. De toute manière, vous devrez déposer votre document dans ce format à la Faculté des études supérieures et postdoctorales.

* Remède pour ceux qui insistent: l'erreur semble survenir avec le lecteur DVI de MiKTeX 2.9. Pour régler le problème, il faut modifier les réglages de Yap ainsi: éditer les options; dans l'onglet «Display», changer «Default render method» de «Default» à «dvips».
