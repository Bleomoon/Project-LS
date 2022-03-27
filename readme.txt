type valuation: Nous n'avons pas crée de type valuation, c'est simplement une liste de (char * int)
Fonctions associés :
- valuation_change : Prend un nom en char, n int et une list de valuation, compare chaque valuation avec le nom envoyé et si elle match change le int avec n sinon crée une nouvelle valuation


type aexp: Composé d'un char ou d'un int ou d'un operator et 2 expression arithmetique
type operator = Est soit un Add, un Minus ou un Mult
Fonctions associés :
	- ope_to_string: Transforme un operator en string ("-", "+", "*")
	- aexp_to_string: Transforme une expression aexp en string
	- ainterp_ter: Match l'operator pour faire un + ou - ou *
	- ainterp_bis:  Match le nom avec la liste valuation envoyé et retourne un int si il le trouve
	- ainterp: Calcul le résultat d'une expression aexp, elle se base sur une liste de valuation, si il manque une valeur entre la liste donné et l'expression cela renvoie une erreur
	- asubst: Substitue une Var par une aexp dans une aexp.


type bexp: Composé de d'un True, False, d'un Neg qui est connectorN et bexp,  d'un BinaryBexp qui est un connectorBexp et 2 Bexp, d'un EqualAexp qui est un connectorAexp et 2 aexp, d'un InfEqAexp qui est un connectorAexp et 2 aexp.
type connectorN : Qui est Not
type connectorAexp : Qui est soit Equal soit InfEqual
type connectorBexp : Qui est And ou Or
Fonctions associés :
	- connectorN_to_string: Traduit un connectorN en string
	- connectorA_to_string: Traduit un connectorA en string
	- connectorB_to_string: Traduit un connectorB en string
	- bexp_to_string: Traduit un bexp en string
	- binterp: Renvoie vrai ou faux si l'expression bexp est vrai ou fausse, elle nécessite une liste_valuation.


type prog: Composé d'un Skip, d'un Affect qui à un aexp et un affect et un aexp, d'un Seq qui a 2 prog, d'une Condition qui a 3 conditions et 2 progs et 1 bexp, d'un Repeat qui à un 3 loop et un aexp et un prog.
type affect : Qui a AFFECT
type cond : Qui a IF ou THEN ou ELSE
type loop : Qui a REPEAT ou DO ou OD
Fonctions associés :
	- cond_to_string : Transforme une cond en string
	- affect_to_string : Transforme un affect en string
	- loop_to_string : Transforme une une loop en string
	- prog_to_string : Transforme un prog en string
	- selfcompose: Prend une fonction et un int et répète cette fonction le nombre de fois du int.
	- exec : Execute le programme et renvoie une liste de valuation qui sont les valeurs obtenus à la suite des calculs du progs.


Une simple modification par rapport au bexp, pour évité les confusion nous avons reprogrammer entrièrement le type sans utilisé de bexp.
type tprop: Composé de d'un TrueP, FalseF, d'un NegP qui est connectorCoN et tprop, d'un BinaryPexp qui est un connectorCoPexp et 2 tprop, d'un ImplPexp qui est un tpropCoPexp et 2 tprop, d'un EqualPAexp qui est un connectorCoAexp et 2 aexp, d'un InfPEqAexp qui est un connectorCoAexp et 2 aexp.
type tpropCoN = Est le Not
type tpropCoAexp = Est Equals ou InfEqual
type tpropCoPexp = Est And ou Or
type tpropCoPimp = Est Implicit
Fonctions associés :
	- tpropCoA_to_string : Traduit un tpropCoAexp en string
	- tpropCoP_to_string : Traduit un tpropCoPexp en string
	- tpropCoPi_to_string : Traduit un tpropCoPimp en string
	- tpropCoN_to_string : Traduit un tpropCoN en string
	- prop_to_string : Transforme un tprop en string
	- pinterp : Renvoie un booléen qui est le résultat du tprop après valuation, elle utilise une liste de valuation 
	- psubst : Remplace une variable par une aexp dans un tprop.


type hoare_triple: Composé d'un tprop et un prog et un tprop
Fonctions associés :
	- htvalid_test : renvoie vrai ou faux si le triplet de hoare est vrai ou faux, elle utilise également une liste de valuation
	- hoare_triple_to_string : Transforme un triple de hoare en string


type tconclusion: SOit un Hoare de type Hoare_triple soit une formule de type tprop
type tgoal: Une liste de couple string * tprop et une tconclusion
Fonctions associés :
	- print_formule_list: Affiche une formule.
	- tgoal_print		: Affiche un tgoal.
	- fresh_ident		: Genere une clé sous la forme d'un string pour la formule.
	- add_formule_goal	: Ajoute une formule a un goal?
	- create_goal		: Crée un tgoal a partir d'une conclusion. 
	- create_goal_with_formule: Crée un tgoal à partir d'une conclusion et d'une formule.


La fonction bool2prop : Transforme un bexp en tprop

type prop_tactics: C'est un And_Intro, Or_Intro_1, Or_Intro_2, Impl_Intro, Not_Intro, And_Elim_1 qui est un string, And_Elim_2 qui est un string, Or_Elim qui est un string, Impl_Elim qui sont 2 string, Not_Elim qui sont 2 string, Assume, Exact ou Admit
Fonctions associés:
	- and_intro	: Applique la tactique and_intro sur un goal.
	- or_intro_1: Applique la tactique or_intro_1 sur un goal.
	- or_intro_2: Applique la tactique or_intro_2 sur un goal.
	- impl_intro: Applique la tactique impl_intro sur un goal.
	- not_intro	: Applique la tactique not_intro sur un goal.
	- and_elim_1: Applique la tactique and_elim_1 sur un goal avec la clé de la formule.
	- and_elim_2: Applique la tactique and_elim_2 sur un goal avec la clé de la formule.
	- or_elim 	: Applique la tactique or_elim sur un goal avec la clé de la formule.
	- impl_elim	: Applique la tactique impl_elim sur un goal avec deux clé de formules.
	- not_elim	: Applique la tactique not_elim sur un goal avec deux clé de formules.

	- apply_prop_tactic: Lance les fonctions de tactique en fonction du la tactique donnée sur le goal.  

type hoare_tactics: C'est un Hskip, HAssign, Hif, Hrepeat, Hcons, Hseq
Fonctions associés:
	- hassign	: Pas terminé non plus nous n'avons pas compris le principe de vérifié que un tprop est égale à [1/i]I
	- hskip		: Effectue un skip, elle vérifie que les deux tprop soit vrai et renvoie un goal vide
	- hif		: Vérifie que le triple d'hoare est correct puis crée deux nouveau triple ce qui supprime la Condition
	- hrepeat	: Vérifie que le triple d'hoare est correct puis un repeat nous donne (I)repeat x do c od(I /\ x = 0) devient donc (I /\ Not(x = 0))c(I) et on introduit un nouveau triplet supprimant l'ancien
	- hcons		: Non terminé, nous n'avons pas compris ce qu'il fallait faire, le cons renvoie donc une liste vide et ne fonctionne pas
	- hseq		: Vérifie que le triple est correct, s'il l'est renvoie 2 nouveau triple avec un nouveau tprop entre les deux programmes, actuellement le tprop est seulement un TrueP

	- apply_hoare_tactic: Applique une tactic de hoare au propositions

type ttactic: Soit un Prop_tactics soir un Hoare_tactics
Fonctions associés:
	- search_from_key	: Recherche une formule dans le goal depuis une clé et renvoie la position dans la liste.
	- change_nth_formule: Renvoie une liste de formule ou la formule a la position n a été remplacé par la formule envoyé en parametre.