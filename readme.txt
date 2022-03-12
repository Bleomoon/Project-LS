Notre type structuré aexp:

		noeud

feuille 			feuille

Un noeud contient un operateur, une feuille une constante ou une variable.

Les fonctions de aexp:
-aexp_to_string: parcours l'arbre et retourne un string parenthésé, une expression de type 2 + 3 + 4 * 5 retournera (2 + 3) + 4 * 5



Notre type valuation:


Les fonctions de valuation:
-ainterp: 