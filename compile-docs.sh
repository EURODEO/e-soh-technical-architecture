#!/bin/bash

set -ve

GIT_REPO_NAME="e-soh-technical-architecture"
GIT_REPO_URL=${GIT_REPO_URL:-https://github.com/EURODEO/e-soh-technical-architecture}

VERSION=${VERSION:-main}

# For local testing, use this:
#VERSION=<issue-branch>

IMAGES_DIR=${IMAGES_DIR:-images}
PDF_THEMES_DIR=${PDF_THEMES_DIR:-source}
HTML_DIR=${HTML_DIR:-html}
PDF_DIR=${PDF_DIR:-pdf}

asciidoctor -r asciidoctor-diagram \
      -a toc=left \
      -a imagesdir=$IMAGES_DIR \
      -a data-uri=Yes \
      -n source/technical-architecture-design.adoc \
      -D $HTML_DIR
  
asciidoctor-pdf -r asciidoctor-diagram \
      -a pdf-themesdir=$PDF_THEMES_DIR \
      -a pdf-theme=poc \
      -a imagesdir=$IMAGES_DIR \
      -n source/technical-architecture-design.adoc \
      -D $PDF_DIR

cp $HTML_DIR/technical-architecture-design.html docs/index.html
cp -r source/$IMAGES_DIR docs/
