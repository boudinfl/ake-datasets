#!/usr/bin/python
# -*- coding: utf-8 -*-

"""
:Name:
	extract_raw_text.py

:Authors:
    Florian Boudin (florian.boudin@univ-nantes.fr)

:Date:
    16 nov 2012 (creation)

"""

import os
import re
import sys
import codecs
import getopt
import string

################################################################################
# Définition de la fonction principale
################################################################################
def main(argv):

	# Test du nombre d'arguments
	if len(argv) != 2:
		print "Usage : extract_raw_text.py fichier_entrée fichier_sortie"
		sys.exit()

	# Récupération du chemin du fichier d'entrée
	fichier = argv[0]
	fichier_sortie = argv[1]

	# Test de l'existance du fichier
	if not os.path.exists(fichier):
		print "-> Le fichier d'entrée n'existe pas"
		sys.exit()

	# Parsing du fichier
	document = parse_html(fichier)
	#document = re.sub('<h\d>[^<]+</h\d>', '', document)
	document = re.sub(u'</(p|h\d)>', ' --BREAKLINE-- ', document)
	document = re.sub(u'</?[^>]+>', ' ', document)
	document = re.sub(u'\s+', ' ', document)
	document = re.sub(u'(?xumsi)[^\w\s.,;:\\/%"\'\’\-«»\(\)\[\]=\+`$€\|<>\n]', '', document)
	document = re.sub(u' --BREAKLINE-- ', '\n\n', document)
	document = document.strip()

	handle = codecs.open(fichier_sortie, 'w', 'utf-8')
	handle.write(document)
	handle.close()


################################################################################

################################################################################
# Fonction de parsing du fichier html
################################################################################
def parse_html(chemin_fichier):

	# Variable tampon pour le contenu du fichier
	tampon = ''

	# Lecture sequentielle du fichier
	for line in codecs.open(chemin_fichier, 'r', 'utf-8'):
		tampon += line.strip()

	body = re.sub('^.*<body>(.+)</body>.*$', '\g<1>', tampon)

	return body
################################################################################


if __name__ == "__main__":
    main(sys.argv[1:])