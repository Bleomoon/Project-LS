type valuation: composé de ...
	
Fonctions associés :
	-valuation_change

type aexp: composé de ...

type operator = composé de ...

Fonctions associés :
	- ope_to_string:
	- aexp_to_string:
	- ainterp_ter:
	- ainterp_bis:
	- ainterp:
	- asubst

type bexp: Composé de ...

type connectorN : Composé de ...
type connectorAexp : Composé de ...
type connectorBexp : Composé de ...

Fonctions associés :
	- connectorN_to_string:
	- connectorA_to_string:
	- connectorB_to_string:
	- bexp_to_string
	- binterp:

type prog: Composé de ...

type affect : Composé de ...
type cond : Composé de ...
type loop : Composé de ...

Fonctions associés :
	- cond_to_string
	- affect_to_string
	- loop_to_string
	- prog_to_string
	- selfcompose: 
	- exec

type tprop: Composé de ...

type tpropCoN = Composé de ...
type tpropCoAexp = Composé de ...
type tpropCoPexp = Composé de ...
type tpropCoPimp = Composé de ...

Fonctions associés :
	- tpropCoA_to_string
	- tpropCoP_to_string
	- tpropCoPi_to_string
	- tpropCoN_to_string
	- prop_to_string
	- pinterp
	- psubst

type hoare_triple: composé de ...

Fonctions associés :
	- htvalid_test