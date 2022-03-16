Nous avons :
-aexp
-bexp
-

Qui sont des classes chacunes acceptant certaines valeurs, pour aexp on acceptes des nombres, constantes de 1 valeur comme x ou y ainsi que +, - et *.
Nous avons ensuite typeExpression qui est une classe abstraite, bexp, aexp et ... hérite de typeExpression.
Elle à un constructeur par recopie et un constructeur avec un string, elle possède également une fonction isValid qui vérifie la cohérence du string envoyé,
cet fonction est abstraite pour typeExpression et définit dans chaque classe fille. Elle possède un setter et un getter.

Finalement nous avons Expression, cet classe est comme un  arbre binaire, elle a un typeExpression sur sa racine et 2 pointeurs sur des typeExpression,
ce sont les fils gauche et droit.

Sur une expression: 2 + 3, le + est la racine, 2 le fils gauche et 3 le fils droit.
Expression à la fonction exp_to_string qui premet de renvoyer sous un string n'importe quel expression, les fonctions aexp et bexp sont alors inutiles.


Notre classe valuation possède un constructeur qui prend deux strings ainsi qu'une fonction d'ajout dans le vecteurs et une fonctions getVariables.



Le main:
on y retrouve certaines fonctions demander dans le projet:
asubst, ainterp.