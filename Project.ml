open ;;

(*1.1 Expressions arithmetiques*)
(*1.1.1 Syntaxe abstraite *)
type operator = | Add | Minus | Mult;;
type aexp =
  | Var of char
  | Cst of int
  | Binary of operator * aexp * aexp;;

let exp1 = Cst(2);;
let exp2 = Binary(Add, Cst(2), Cst(3));;
let exp3 = Binary(Minus, Cst(2), Cst(5));;
let exp4 = Binary(Mult, Cst(3), Cst(6));;
let exp5 = Binary(Add, Cst(2), Var('x'));;
let exp6 = Binary(Mult, Cst(3), Binary(Mult, Var('x'), Var('x')));;
let exp7 = Binary(Add, Binary(Mult, Cst(5), Var('x')), Binary(Mult, Cst(7), Var('y')));;
let exp8 = Binary(Add, Binary(Mult, Cst(6), Var('y')), Binary(Mult, Cst(5), Binary(Mult, Var('y'), Var('x'))));;

let ope_to_string operator =
  match operator with
  | Add -> "+"
  | Minus -> "-"
  | Mult -> "*"
;;

let rec aexp_to_string aexp =
  match aexp with
  | Var(v) -> String.make 1 v
  | Cst(c) -> string_of_int c
  | Binary(op, fg, fd) -> "(" ^ (aexp_to_string fg) ^ (ope_to_string op) ^ (aexp_to_string fd) ^ ")"
;;

aexp_to_string(exp1);;
aexp_to_string(exp2);;
aexp_to_string(exp3);;
aexp_to_string(exp4);;
aexp_to_string(exp5);;
aexp_to_string(exp6);;
aexp_to_string(exp7);;
aexp_to_string(exp8);;

(*1.1.2 Interprétation*)
type valuation = (char * int) list;;

let ainterp_ter x y op =
  match op with
  | Add -> x + y
  | Mult -> x * y
  | Minus -> x - y
;;

let rec ainterp_bis(name, list) : int =
  begin match list with
  | (x,y)::[] -> if(name = x) then y else 0
  | (x,y)::tl -> if(name = x) then y else ainterp_bis(name, tl)
  end
;;

let rec ainterp(aexp, list_valuation) =
  begin match aexp with
     | Var(v) -> ainterp_bis(v, list_valuation)
     | Cst(c) -> c
     | Binary(op, fg, fd) ->
        begin match fg, fd with
        | Cst(c1), Cst(c2) -> (ainterp_ter c1 c2 op)
        | _, Cst(c2) -> (ainterp_ter (ainterp(fg, list_valuation)) c2 op)
        | Cst(c1), _ -> (ainterp_ter c1 (ainterp(fd, list_valuation)) op)
        | _, _ -> (ainterp_ter (ainterp(fg, list_valuation)) (ainterp(fd, list_valuation)) op)
        end
  end
;;


let valua = [('x', 5);('y', 9)];;

ainterp(exp1, valua);;
ainterp(exp2, valua);;
ainterp(exp3, valua);;
ainterp(exp4, valua);;
ainterp(exp5, valua);;
ainterp(exp6, valua);;
ainterp(exp7, valua);;
ainterp(exp8, valua);;


(*1.1.3 Substitutions*)

let rec asubst name aexp1 aexp2 =
  match aexp2 with
  | Var(v) -> if (v == name) then aexp1 else Var(v)
  | Cst(c) -> Cst(c)
  | Binary(op, fg, fd) -> Binary(op, (asubst name aexp1 fg), (asubst name aexp1 fd))
;;

aexp_to_string((asubst 'x' (Cst(5)) exp5));;
aexp_to_string((asubst 'y' (Binary(Add, Var('z'), Cst(2))) exp7));;

(*1.2 Les expressions booléennes*)
(*1.2.1 Syntaxe abstraite*)
type connector = | Equal | InfEqual | And | Or | Not;;
type bexp =
  | True
  | False
  | Neg of connector * bexp
  | BinaryBexp of connector * bexp * bexp
  | EqualAexp of connector * aexp *  aexp
  | InfEqAexp of connector * aexp *  aexp
;;

let connector_to_string connector =
  match connector with
  | Equal -> "="
  | InfEqual -> "<="
  | And -> "et"
  | Or -> "ou"
  | Not -> "non"
;;

let exp11 = True;;
let exp12 = BinaryBexp(And, True, False);;
let exp13 = Neg(Not, True);;
let exp14 = BinaryBexp(Or, True, False);;
let exp15 = EqualAexp(Equal, Cst(2), Cst(4));;
let exp16 = EqualAexp(Equal,  Binary(Add, Cst(3), Cst(5)), Binary(Mult, Cst(2), Cst(4)));;
let exp17 = EqualAexp(Equal,  Binary(Mult, Cst(2), Var('x')), Binary(Add, Var('y'), Cst(1)));;
let exp18 = InfEqAexp(InfEqual, Cst(5), Cst(7));;
let exp19 = BinaryBexp(And, InfEqAexp(InfEqual,  Binary(Add, Cst(8), Cst(9)), Binary(Mult, Cst(4), Cst(5))), InfEqAexp(InfEqual,  Binary(Add, Cst(3), Var('x')), Binary(Mult, Cst(4), Var('y'))));;

let rec bexp_to_string bexp =
  match bexp with
  | True -> "vrai"
  | False -> "faux"
  | Neg(op, fd) -> "(" ^ connector_to_string(op) ^ " " ^ bexp_to_string(fd) ^ ")"
  | BinaryBexp(op, fg, fd) -> "(" ^ bexp_to_string(fg) ^ " " ^ connector_to_string(op) ^ " " ^ bexp_to_string(fd) ^ ")"
  | EqualAexp(op, fg, fd) -> "(" ^ aexp_to_string(fg) ^ " " ^ connector_to_string(op) ^ " " ^ aexp_to_string(fd) ^ ")"
  | InfEqAexp(op, fg, fd) -> "(" ^ aexp_to_string(fg) ^ " " ^ connector_to_string(op) ^ " " ^ aexp_to_string(fd) ^ ")"
;;

bexp_to_string(exp11);;
bexp_to_string(exp12);;
bexp_to_string(exp13);;
bexp_to_string(exp14);;
bexp_to_string(exp15);;
bexp_to_string(exp16);;
bexp_to_string(exp17);;
bexp_to_string(exp18);;
bexp_to_string(exp19);;


(*1.2.1 Interprétation *)
let rec binterp(bexp, list_valuation) =
  begin match bexp with
  | True -> true
  | False -> false
  | Neg(op, bexpB) ->
     begin match bexpB with
     | True -> false
     | False -> true
     | _ -> if((binterp(bexpB, list_valuation)) == true) then false else true
     end
  | BinaryBexp(op, fg, fd) ->
     begin match fg, fd with
     | True, True -> true
     | True, False -> false
     | True, _ -> if((binterp(fd, list_valuation)) == true) then true else false
     | False, True -> false
     | False, False -> false
     | False, _ -> false
     | _ , True -> if((binterp(fg, list_valuation)) == true) then true else false
     | _, False -> false
     | _, _ -> if( (binterp(fd, list_valuation)) == true) then (binterp(fg, list_valuation)) else false
     end
  | EqualAexp(op, fg, fd) ->
     begin match fg, fd with
     | Cst(s1), Cst(s2) -> if(s1 == s2) then true else false
     | Var(s1), Cst(s2) -> if((ainterp_bis(s1, list_valuation)) == s2) then true else false
     | Cst(s1), Var(s2) -> if((ainterp_bis(s2, list_valuation)) == s1) then true else false
     | _, _ -> if( (ainterp(fg, list_valuation)) == (ainterp(fd, list_valuation))) then true else false
     end
  | InfEqAexp(op, fg, fd) ->
     begin match fg, fd with
     | Cst(s1), Cst(s2) -> if(s1 <= s2) then true else false
     | Var(s1), Cst(s2) -> if((ainterp_bis(s1, list_valuation)) <= s2) then true else false
     | Cst(s1), Var(s2) -> if((ainterp_bis(s2, list_valuation)) <= s1) then true else false
     | _, _-> if( (ainterp(fg, list_valuation)) <= (ainterp(fd, list_valuation))) then true else false
     end
  end
;;

let valuaB = [('x', 7);('y', 3)];;

binterp(exp11, valuaB);;
binterp(exp12, valuaB);;
binterp(exp13, valuaB);;
binterp(exp14, valuaB);;
binterp(exp15, valuaB);;
binterp(exp16, valuaB);;
binterp(exp17, valuaB);;
binterp(exp18, valuaB);;
binterp(exp19, valuaB);;

(*1.3 Les commandes du langage *)
(*1.3.1 Syntaxe abstraite *)
type affect = | AFFECT;;
type cond = | IF | THEN | ELSE;;
type loop = | REPEAT | DO | OD;;
type prog =
  | Skip
  | Affect of aexp * affect * aexp
  | Seq of prog * prog
  | Condition of cond * bexp * cond * prog * cond * prog
  | Repeat of loop * aexp * loop * prog * loop
;;

let exp21 = Affect(Var('y'), AFFECT, Cst(7));;
let exp22 = Affect(Var('z'), AFFECT, Binary(Add, Cst(3), Cst(4)));;
let exp23 = Affect(Var('x'), AFFECT, Binary(Mult, Cst(2), Var('x')));;
let exp24 = Affect(Var('n'), AFFECT, Cst(3));;
let exp25 = Condition(IF, InfEqAexp(InfEqual, Var('n'), Cst(4)), THEN, Affect(Var('n'), AFFECT, Binary(Add, Cst(3), Binary(Mult, Cst(2), Var('n')))), ELSE, Affect(Var('n'), AFFECT, Binary(Add, Var('x'), Cst(1))));;
let exp26 = Repeat(REPEAT, Cst(10), DO, Affect(Var('x'), AFFECT, Binary(Add, Var('x'), Cst(1))), OD);;

let cond_to_string cond =
  match cond with
  | IF -> "if"
  | ELSE -> "else"
  | THEN -> "then"
;;

let affect_to_string affect =
  match affect with
  | AFFECT -> ":="
;;

let loop_to_string loop =
  match loop with
  | REPEAT -> "repeat"
  | DO -> "do"
  | OD -> "od"
;;

let rec prog_to_string prog =
  match prog with
  | Skip -> "skip"
  | Affect(aexp1, affect, aexp2) -> aexp_to_string(aexp1) ^ " " ^ affect_to_string(affect) ^ " " ^ aexp_to_string(aexp2)
  | Seq(p1, p2) -> prog_to_string(p1)  ^ " " ^ prog_to_string(p2)
  | Condition(cond1, bexp, cond2, prog1, cond3, prog2) ->  cond_to_string(cond1) ^ "   " ^ bexp_to_string(bexp) ^ " " ^ cond_to_string(cond2) ^ "   " ^ prog_to_string(prog1) ^ " " ^ cond_to_string(cond3)  ^ "   " ^ prog_to_string(prog2)
  | Repeat(loop, aexp, loop2, prog, loop3) -> loop_to_string(loop) ^ " " ^ aexp_to_string(aexp) ^ " " ^ loop_to_string(loop2) ^ "   " ^ prog_to_string(prog) ^ "   " ^ loop_to_string(loop3)
;;

prog_to_string(exp21);;
prog_to_string(exp22);;
prog_to_string(exp23);;
prog_to_string(exp24);;
prog_to_string(exp25);;
prog_to_string(exp26);;


(*1.3.2 Interprétation *)
let rec selfcompose func n : int =
  if (n == 0)
  then (func n)
  else selfcompose func (n-1) + (func 0)
;;

let add n =
  n + 2
;;

selfcompose add 10;;


let exec prog list_valuation =
  match prog with
  | Skip -> 0
  | Affect(aexp1, affect, aexp2) -> (ainterp aexp2 list_valuation)
  | Seq -> of prog * prog
  | Condition(cond1, bexp, cond2, progThen, cond3, progElse) -> if(binterp(bexp, list_valuation)) then exec progThen else exec peogElse
  | Repeat(loop1, aexp, loop2, prog, loop3) -> selfcompose prog (ainterp aexp list_valuation)bleom
;;


(* 1. 4 Triplets de Hoare et validité *)
(*1.4.1 Syntaxe abstraite des formules de la logique des propositions *)
(* Pour évité un double match je vais simplement recrée un type en entier *)
type tpropCo = | Implicit | Equal | InfEqual | And | Or | Not;;
type tprop =
  | True
  | False
  | Neg of tpropCo * tprop
  | BinaryPexp of tpropCo * tprop * tprop
  | ImplPexp of tpropCo * tprop * tprop
  | EqualAexp of tpropCo * aexp *  aexp
  | InfEqAexp of tpropCo * aexp *  aexp
;;

let tpropCo_to_string connector =
  match connector with
  | Equal -> "="
  | InfEqual -> "<="
  | And -> "et"
  | Or -> "ou"
  | Not -> "non"
  | Implicit -> "implique"
;;

let exp30 = True;;
let exp31 = BinaryPexp(And, True, False);;
let exp32 = Neg(Not, True);;
let exp33 = BinaryPexp(Or, True, False);;
let exp34 = ImplPexp(Implicit, False, BinaryPexp(Or, True, False));;
let exp35 = EqualAexp(Equal, Cst(2), Cst(4));;
let exp36 = EqualAexp(Equal,  Binary(Add, Cst(3), Cst(5)), Binary(Mult, Cst(2), Cst(4)));;
let exp37 = EqualAexp(Equal,  Binary(Mult, Cst(2), Var('x')), Binary(Add, Var('y'), Cst(1)));;
let exp38 = InfEqAexp(InfEqual,  Binary(Add, Cst(3), Var('x')), Binary(Mult, Cst(4), Var('y')));;
let exp39 = BinaryPexp(And, InfEqAexp(InfEqual, Cst(5), Cst(7)), InfEqAexp(InfEqual, Binary(Add, Cst(8), Cst(9)), Binary(Mult, Cst(4), Cst(5))));;
let exp39b = ImplPexp(Implicit, EqualAexp(Equal, Var('x'), Cst(1)), InfEqAexp(InfEqual, Var('y'), Cst(0)));;

let rec prop_to_string tprop =
  match tprop with
  | True -> "vrai"
  | False -> "faux"
  | Neg(op, fd) -> "(" ^ tpropCo_to_string(op) ^ " " ^ prop_to_string(fd) ^ ")"
  | BinaryPexp(op, fg, fd) -> "(" ^ prop_to_string(fg) ^ " " ^ tpropCo_to_string(op) ^ " " ^ prop_to_string(fd) ^ ")"
  | ImplPexp(op, fg, fd) -> "(" ^ prop_to_string(fg) ^ " " ^ tpropCo_to_string(op) ^ " " ^ prop_to_string(fd) ^ ")"
  | EqualAexp(op, fg, fd) -> "(" ^ aexp_to_string(fg) ^ " " ^ tpropCo_to_string(op) ^ " " ^ aexp_to_string(fd) ^ ")"
  | InfEqAexp(op, fg, fd) -> "(" ^ aexp_to_string(fg) ^ " " ^ tpropCo_to_string(op) ^ " " ^ aexp_to_string(fd) ^ ")"
;;

prop_to_string(exp30);;
prop_to_string(exp31);;
prop_to_string(exp32);;
prop_to_string(exp33);;
prop_to_string(exp34);;
prop_to_string(exp35);;
prop_to_string(exp36);;
prop_to_string(exp37);;
prop_to_string(exp38);;
prop_to_string(exp39);;
prop_to_string(exp39b);;

(*1.4.2 Interprétation *)
let rec pinterp(pexp, list_valuation) =
  begin match pexp with
  | True -> true
  | False -> false
  | Neg(op, pexpP) ->
     begin match pexpP with
     | True -> false
     | False -> true
     | _ -> if((pinterp(pexpP, list_valuation)) == true) then false else true
     end
  | BinaryPexp(op, fg, fd) ->
     begin match fg, fd with
     | True, True -> true
     | True, False -> false
     | True, _ -> if((pinterp(fd, list_valuation)) == true) then true else false
     | False, True -> false
     | False, False -> false
     | False, _ -> false
     | _ , True -> if((pinterp(fg, list_valuation)) == true) then true else false
     | _, False -> false
     | _, _ -> if( (pinterp(fd, list_valuation)) == true) then (pinterp(fg, list_valuation)) else false
     end
  | ImplPexp(co, p1, p2) -> if(pinterp(p1, list_valuation) == true) then pinterp(p2, list_valuation) else true
  | EqualAexp(op, fg, fd) ->
     begin match fg, fd with
     | Cst(s1), Cst(s2) -> if(s1 == s2) then true else false
     | Var(s1), Cst(s2) -> if((ainterp_bis(s1, list_valuation)) == s2) then true else false
     | Cst(s1), Var(s2) -> if((ainterp_bis(s2, list_valuation)) == s1) then true else false
     | _, _ -> if( (ainterp(fg, list_valuation)) == (ainterp(fd, list_valuation))) then true else false
     end
  | InfEqAexp(op, fg, fd) ->
     begin match fg, fd with
     | Cst(s1), Cst(s2) -> if(s1 <= s2) then true else false
     | Var(s1), Cst(s2) -> if((ainterp_bis(s1, list_valuation)) <= s2) then true else false
     | Cst(s1), Var(s2) -> if((ainterp_bis(s2, list_valuation)) <= s1) then true else false
     | _, _-> if( (ainterp(fg, list_valuation)) <= (ainterp(fd, list_valuation))) then true else false
     end
  end
;;

let valuaP = [('x', 7);('y', 3)];;

pinterp(exp30, valuaP);;
pinterp(exp31, valuaP);;
pinterp(exp32, valuaP);;
pinterp(exp33, valuaP);;
pinterp(exp34, valuaP);;
pinterp(exp35, valuaP);;
pinterp(exp36, valuaP);;
pinterp(exp37, valuaP);;
pinterp(exp38, valuaP);;
pinterp(exp39, valuaP);;
pinterp(exp39b, valuaP);;

(*1.4.3 Substitutions *)
let psubst name aexp pexp =
  begin match pexp with
  | True -> True
  | False -> False
  | Neg(co, prop) -> 
  | BinaryPexp(cp, p1, p2) ->
  | ImplPexp(co, p1, p2) ->
  | EqualAexp(co, aexp1, aexp2) ->
  | InfEqAexp(co, aexp1, aexp2) -> 
  end
;;

prop_to_string(psubst('x', (Binary(Mult, Cst(3), Var('y'))), exp30));;
prop_to_string(psubst('x', (Binary(Mult, Cst(3), Var('y'))), exp31));;
prop_to_string(psubst('x', (Binary(Mult, Cst(3), Var('y'))), exp32));;
prop_to_string(psubst('x', (Binary(Mult, Cst(3), Var('y'))), exp33));;
prop_to_string(psubst('x', (Binary(Mult, Cst(3), Var('y'))), exp34));;
prop_to_string(psubst('x', (Binary(Mult, Cst(3), Var('y'))), exp35));;
prop_to_string(psubst('x', (Binary(Mult, Cst(3), Var('y'))), exp36));;
prop_to_string(psubst('x', (Binary(Mult, Cst(3), Var('y'))), exp37));;
prop_to_string(psubst('x', (Binary(Mult, Cst(3), Var('y'))), exp38));;
prop_to_string(psubst('x', (Binary(Mult, Cst(3), Var('y'))), exp39));;
prop_to_string(psubst('x', (Binary(Mult, Cst(3), Var('y'))), exp39b));;

prop_to_string(psubst('y', (Binary(Add, Var('k'), Cst(2))), exp30));;
prop_to_string(psubst('y', (Binary(Add, Var('k'), Cst(2))), exp31));;
prop_to_string(psubst('y', (Binary(Add, Var('k'), Cst(2))), exp32));;
prop_to_string(psubst('y', (Binary(Add, Var('k'), Cst(2))), exp33));;
prop_to_string(psubst('y', (Binary(Add, Var('k'), Cst(2))), exp34));;
prop_to_string(psubst('y', (Binary(Add, Var('k'), Cst(2))), exp35));;
prop_to_string(psubst('y', (Binary(Add, Var('k'), Cst(2))), exp36));;
prop_to_string(psubst('y', (Binary(Add, Var('k'), Cst(2))), exp37));;
prop_to_string(psubst('y', (Binary(Add, Var('k'), Cst(2))), exp38));;
prop_to_string(psubst('y', (Binary(Add, Var('k'), Cst(2))), exp39));;
prop_to_string(psubst('y', (Binary(Add, Var('k'), Cst(2))), exp39b));;

(*1.4.4 Les triplets de Hoare *)

(*1.4.5 Validité d'un triplet de Hoare *)
