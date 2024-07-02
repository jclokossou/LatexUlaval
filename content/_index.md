---
title: Paquetage ulthese
description: La classe LaTeX pour les thèses et mémoires de l'Université Laval
---

Le paquetage **ulthese** fournit la classe LaTeX du même nom permettant de composer des thèses et des mémoires immédiatement conformes aux [règles générales et complémentaires de présentation](https://www.fesp.ulaval.ca/memoires-et-theses/regles-de-presentation) de la Faculté des études supérieures et postdoctorales (FESP) de l'[Université Laval](https://www.ulaval.ca). 

La composition d'un manuscript avec la classe `ulthese` requiert une distribution TeX récente et à jour. Nous recommandons les distributions [TeX Live](https://tug.org/texlive) --- ou sa variante pour macOS [MacTeX](https://tug.org/mactex) --- et [MiKTeX](https://miktex.org). Vous pouvez également recourir à une plateforme de rédaction en ligne comme [Overleaf](https://overleaf.com).

La classe est compatible avec pdfLaTeX et XeLaTeX.

## Auteur

[Vincent Goulet](https://vigou3.gitlab.io) pour la Faculté des études supérieures de l'Université Laval.

## Plus récente version

{{< param version >}} ({{< param release_date >}}) {{< see-release-notes >}}

## Obtenir et installer la classe

La classe est distribuée dans le paquetage **ulthese** via [CTAN](https://ctan.org/pkg/ulthese). Celui-ci fait partie des distributions TeX standards. Dans la mesure où votre distribution est à jour, vous devriez pouvoir utiliser la classe sans autre intervention.

Nous recommandons fortement d'installer ou de mettre à jour le paquetage à l'aide du [gestionnaire de paquetages de votre distribution TeX](https://tex.stackexchange.com/questions/55437/how-do-i-update-my-tex-distribution). 

Si vous préférez une installation de la classe dont la portée sera limitée à votre projet, téléchargez l'archive ci-dessous et décompressez son contenu dans le répertoire. Vous disposerez alors de tous les fichiers essentiels de la classe, mais uniquement à l'intérieur de ce projet.

{{< archive-button >}}

Enfin, si votre expertise TeX vous pousse à préférer une installation manuelle, [téléchargez le paquetage](https://ctan.org/pkg/ulthese) depuis CTAN et suivez les instructions d'installation qui se trouvent dans le fichier `README.md`.

**Utilisation avec Overleaf**&nbsp; Vous devriez pouvoir utiliser la classe sans autre intervention avec les plateformes de rédaction en ligne comme [Overleaf](https://www.overleaf.com). Si le paquetage **ulthese** n'est pas à jour, installez la classe dans votre projet comme expliqué ci-dessus.

## Documentation

La classe est livrée une documentation complète. Vous pouvez accéder rapidement à celle-ci avec [Texdoc](https://tug.org/texdoc/), soit via votre éditeur LaTeX, soit depuis la ligne de commande avec
```
texdoc ulthese
```

## Commentaires et suggestions

Le [dépôt du projet](https://gitlab.com/vigou3/ulthese/) dans GitLab demeure le meilleur endroit pour rapporter des bogues ou pour proposer des améliorations à la classe.

## Licence

LaTeX Project Public License, [version 1.3c](https://www.latex-project.org/lppl/lppl-1-3c) ou (à votre choix) toute version ultérieure. 

<!-- Local Variables: -->
<!-- eval: (auto-fill-mode -1) -->
<!-- eval: (visual-line-mode) -->
<!-- End: -->
