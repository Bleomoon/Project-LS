open List;;
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

(*1.1.2 Interprtation*)
type valuation = (char * int) list;;

let rec valuation_change(name, n, list_valuation)   =
  begin match list_valuation with
  | [] -> [(name, n)]
  | ((x,y)::tl) ->
     if name = x
     then ((name,n)::tl)
     else (x,y)::(valuation_change(name, n, tl)) 
  end
;;

let ainterp_ter x y op =
  match op with
  | Add -> x + y
  | Mult -> x * y
  | Minus -> x - y
;;

let rec ainterp_bis(name, list) : int =
  begin match list with
  | [] -> failwith "Could not interpret aexp"
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

(*1.2 Les expressions boolennes*)
(*1.2.1 Syntaxe abstraite*)
type connectorN = | Not;;
type connectorAexp = | Equal | InfEqual;;
type connectorBexp = | And | Or;;
type bexp =
  | True
  | False
  | Neg of connectorN  * bexp
  | BinaryBexp of connectorBexp * bexp * bexp
  | EqualAexp of connectorAexp * aexp *  aexp
  | InfEqAexp of connectorAexp * aexp *  aexp
;;

let connectorN_to_string connectorN =
  match connectorN with
  | Not -> "non"
;;

let connectorA_to_string connectorAexp =
  match connectorAexp with
  | Equal -> "="
  | InfEqual -> "<="
;;

let connectorB_to_string connectorBexp =
  match connectorBexp with
  | And -> "et"
  | Or -> "ou"
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
  | Neg(op, fd) -> "(" ^ connectorN_to_string(op) ^ " " ^ bexp_to_string(fd) ^ ")"
  | BinaryBexp(op, fg, fd) -> "(" ^ bexp_to_string(fg) ^ " " ^ connectorB_to_string(op) ^ " " ^ bexp_to_string(fd) ^ ")"
  | EqualAexp(op, fg, fd) -> "(" ^ aexp_to_string(fg) ^ " " ^ connectorA_to_string(op) ^ " " ^ aexp_to_string(fd) ^ ")"
  | InfEqAexp(op, fg, fd) -> "(" ^ aexp_to_string(fg) ^ " " ^ connectorA_to_string(op) ^ " " ^ aexp_to_string(fd) ^ ")"
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


(*1.2.1 Interprtation *)
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
     begin match op with
     | Or -> 
        begin match fg, fd with
        | True, _ -> true
        | _, True -> true
        | False, False -> false
        | False, _ -> if( (binterp(fd, list_valuation)) == true) then true else false
        | _ , False -> if((binterp(fg, list_valuation)) == true) then true else false
        | _, _ -> if( (binterp(fd, list_valuation)) == true) then true else  (binterp(fg, list_valuation))
        end
     | And ->
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


(*1.3.2 Interprtation *)
let rec selfcompose func n =
  if n = 0
  then  fun prog ->  prog
  else
    if n = 1
    then fun prog ->  func prog
    else fun prog ->  func (selfcompose (func) (n-1) prog)
;;

let add n = n + 2;;
let calul = (selfcompose add 10) 0;;

let rec exec prog list_valuation =
  match prog with
    Repeat(loop1, aexp, loop2, prog, loop3) ->
     let func = (selfcompose (exec prog) (ainterp(aexp,list_valuation)))
     in func list_valuation
  | Skip -> list_valuation
  | Affect(aexp1, affect, aexp2) ->
     begin match aexp1 with
     | Var(v) -> valuation_change(v, (ainterp(aexp2,list_valuation)), list_valuation)
     | _ -> valuation_change('p', (ainterp(aexp2,list_valuation)), list_valuation)
     end
  | Seq(prog1, prog2) -> (exec prog2 (exec prog1 list_valuation))
  | Condition(cond1, bexp, cond2, progThen, cond3, progElse) -> if(binterp(bexp, list_valuation)) then (exec progThen list_valuation) else (exec progElse list_valuation)
;;

let prog_facto =
  Repeat(REPEAT, Var('n'), DO, Seq(Affect(Var('x'), AFFECT, Binary(Mult, Var('x'), Var('n'))), Affect(Var('n'), AFFECT, Binary(Minus, Var('n'), Cst(1)))), OD)
;;

let valuafacto = [('x', 1);('n', 5)];;
exec prog_facto valuafacto;;

let prog_fibo =
  Repeat(REPEAT, Var('n'), DO, Seq(Affect(Var('p'), AFFECT, Var('x')), Seq(Affect(Var('x'), AFFECT, Binary(Add, Var('x'), Var('y'))), Affect(Var('y'), AFFECT, Var('p')))), OD)
;;
let valuafibo = [('x', 0);('n', 9); ('y', 1)];;
exec  prog_fibo valuafibo;;

(* 1. 4 Triplets de Hoare et validit *)
(*1.4.1 Syntaxe abstraite des formules de la logique des propositions *)
(* Pour vit un double match je vais simplement recre un type en entier *)
type tpropCoN = | Not;;
type tpropCoAexp = | Equal | InfEqual;;
type tpropCoPexp = | And | Or;;
type tpropCoPimp = | Implicit;;
type tprop =
  | TrueP
  | FalseP
  | NegP of tpropCoN * tprop
  | BinaryPexp of tpropCoPexp * tprop * tprop
  | ImplPexp of tpropCoPimp * tprop * tprop
  | EqualPAexp of tpropCoAexp * aexp *  aexp
  | InfPEqAexp of tpropCoAexp * aexp *  aexp
;;

let tpropCoA_to_string tpropCoAexp =
  match tpropCoAexp with
  | Equal -> "="
  | InfEqual -> "<="
;;

let tpropCoP_to_string tpropCoPexp =
  match tpropCoPexp with
  | And -> "et"
  | Or -> "ou"
;;

let tpropCoPi_to_string tpropCoPimp =
  match tpropCoPimp with
  | Implicit -> "implique"
;;

let tpropCoN_to_string tpropCoN =
  match tpropCoN with
  | Not -> "non"
;;

let exp30 = TrueP;;
let exp31 = BinaryPexp(And, TrueP, FalseP);;
let exp32 = NegP(Not, TrueP);;
let exp33 = BinaryPexp(Or, TrueP, FalseP);;
let exp34 = ImplPexp(Implicit, FalseP, BinaryPexp(Or, TrueP, FalseP));;
let exp35 = EqualPAexp(Equal, Cst(2), Cst(4));;
let exp36 = EqualPAexp(Equal,  Binary(Add, Cst(3), Cst(5)), Binary(Mult, Cst(2), Cst(4)));;
let exp37 = EqualPAexp(Equal,  Binary(Mult, Cst(2), Var('x')), Binary(Add, Var('y'), Cst(1)));;
let exp38 = InfPEqAexp(InfEqual,  Binary(Add, Cst(3), Var('x')), Binary(Mult, Cst(4), Var('y')));;
let exp39 = BinaryPexp(And, InfPEqAexp(InfEqual, Cst(5), Cst(7)), InfPEqAexp(InfEqual, Binary(Add, Cst(8), Cst(9)), Binary(Mult, Cst(4), Cst(5))));;
let exp39b = ImplPexp(Implicit, EqualPAexp(Equal, Var('x'), Cst(1)), InfPEqAexp(InfEqual, Var('y'), Cst(0)));;

let rec prop_to_string tprop =
  match tprop with
  | TrueP -> "vrai"
  | FalseP -> "faux"
  | NegP(op, fd) -> "(" ^ tpropCoN_to_string(op) ^ " " ^ prop_to_string(fd) ^ ")"
  | BinaryPexp(op, fg, fd) -> "(" ^ prop_to_string(fg) ^ " " ^ tpropCoP_to_string(op) ^ " " ^ prop_to_string(fd) ^ ")"
  | ImplPexp(op, fg, fd) -> "(" ^ prop_to_string(fg) ^ " " ^ tpropCoPi_to_string(op) ^ " " ^ prop_to_string(fd) ^ ")"
  | EqualPAexp(op, fg, fd) -> "(" ^ aexp_to_string(fg) ^ " " ^ tpropCoA_to_string(op) ^ " " ^ aexp_to_string(fd) ^ ")"
  | InfPEqAexp(op, fg, fd) -> "(" ^ aexp_to_string(fg) ^ " " ^ tpropCoA_to_string(op) ^ " " ^ aexp_to_string(fd) ^ ")"
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

(*1.4.2 Interprtation *)
let rec pinterp(pexp, list_valuation) =
  begin match pexp with
  | TrueP -> true
  | FalseP -> false
  | NegP(op, pexpP) ->
     begin match pexpP with
     | TrueP -> false
     | FalseP -> true
     | _ -> if((pinterp(pexpP, list_valuation)) == true) then false else true
     end
  | BinaryPexp(op, fg, fd) ->
     begin match op with
     | Or -> 
        begin match fg, fd with
        | TrueP, _ -> true
        | _, TrueP -> true
        | FalseP, FalseP -> false
        | FalseP, _ -> if( (pinterp(fd, list_valuation)) == true) then true else false
        | _ , FalseP -> if((pinterp(fg, list_valuation)) == true) then true else false
        | _, _ -> if( (pinterp(fd, list_valuation)) == true) then true else  (pinterp(fg, list_valuation))
        end
     | And ->
        begin match fg, fd with
        | TrueP, TrueP -> true
        | TrueP, FalseP -> false
        | TrueP, _ -> if((pinterp(fd, list_valuation)) == true) then true else false
        | FalseP, TrueP -> false
        | FalseP, FalseP -> false
        | FalseP, _ -> false
        | _ , TrueP -> if((pinterp(fg, list_valuation)) == true) then true else false
        | _, FalseP -> false
        | _, _ -> if( (pinterp(fd, list_valuation)) == true) then (pinterp(fg, list_valuation)) else false
        end
     end
  | ImplPexp(co, p1, p2) -> if(pinterp(p1, list_valuation) == true) then pinterp(p2, list_valuation) else true
  | EqualPAexp(op, fg, fd) ->
     begin match fg, fd with
     | Cst(s1), Cst(s2) -> if(s1 == s2) then true else false
     | Var(s1), Cst(s2) -> if((ainterp_bis(s1, list_valuation)) == s2) then true else false
     | Cst(s1), Var(s2) -> if((ainterp_bis(s2, list_valuation)) == s1) then true else false
     | _, _ -> if( (ainterp(fg, list_valuation)) == (ainterp(fd, list_valuation))) then true else false
     end
  | InfPEqAexp(op, fg, fd) ->
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
let rec psubst name aexp pexp =
  begin match pexp with
  | TrueP -> TrueP
  | FalseP -> FalseP
  | NegP(co, prop) -> NegP(co, (psubst name aexp prop))
  | BinaryPexp(co, p1, p2) -> BinaryPexp(co, (psubst name aexp p1), (psubst name aexp p2))
  | ImplPexp(co, p1, p2) -> ImplPexp(co, (psubst name aexp p1), (psubst name aexp p2))
  | EqualPAexp(co, aexp1, aexp2) -> EqualPAexp(co, (asubst name aexp aexp1), (asubst name aexp aexp2))
  | InfPEqAexp(co, aexp1, aexp2) -> InfPEqAexp(co, (asubst name aexp aexp1), (asubst name aexp aexp2))
  end
;;

let aexpTest = Binary(Mult, Cst(3), Var('y'));;
let aexpTest2 = Binary(Add, Var('k'), Cst(2));;

prop_to_string((psubst 'x' aexpTest exp30));;
prop_to_string((psubst 'x' aexpTest exp31));;
prop_to_string((psubst 'x' aexpTest exp32));;
prop_to_string((psubst 'x' aexpTest exp33));;
prop_to_string((psubst 'x' aexpTest exp34));;
prop_to_string((psubst 'x' aexpTest exp35));;
prop_to_string((psubst 'x' aexpTest exp36));;
prop_to_string((psubst 'x' aexpTest exp37));;
prop_to_string((psubst 'x' aexpTest exp38));;
prop_to_string((psubst 'x' aexpTest exp39));;
prop_to_string((psubst 'x' aexpTest exp39b));;

prop_to_string((psubst 'y' aexpTest2 exp30));;
prop_to_string((psubst 'y' aexpTest2 exp31));;
prop_to_string((psubst 'y' aexpTest2 exp32));;
prop_to_string((psubst 'y' aexpTest2 exp33));;
prop_to_string((psubst 'y' aexpTest2 exp34));;
prop_to_string((psubst 'y' aexpTest2 exp35));;
prop_to_string((psubst 'y' aexpTest2 exp36));;
prop_to_string((psubst 'y' aexpTest2 exp37));;
prop_to_string((psubst 'y' aexpTest2 exp38));;
prop_to_string((psubst 'y' aexpTest2 exp39));;
prop_to_string((psubst 'y' aexpTest2 exp39b));;

(*1.4.4 Les triplets de Hoare *)
type hoare_triple =
  | HOARET of tprop * prog * tprop
;;

let tpHoare1 = HOARET(EqualPAexp(Equal, Var('x'), Cst(2)), Skip, EqualPAexp(Equal, Var('x'), Cst(2)));;
let tpHoare2 = HOARET(EqualPAexp(Equal, Var('x'), Cst(2)), Affect(Var('x'), AFFECT, Cst(3)), InfPEqAexp(InfEqual, Var('x'), Cst(3)));;
let tpHoare3 = HOARET(TrueP, Condition(
                                IF,
                                InfEqAexp(InfEqual, Var('x'), Cst(0)),
                                THEN,
                                Affect(Var('r'), AFFECT, Binary(Minus, Cst(0), Var('x'))),
                                ELSE,
                                Affect(Var('r'), AFFECT, Var('x'))),
                      InfPEqAexp(InfEqual, Cst(0), Var('r'))
                 );;
(*Ici in est n et out est x*)                                                                            
let tpHoare4 = HOARET(BinaryPexp(And, EqualPAexp(Equal, Var('n'), Cst(5)), EqualPAexp(Equal, Var('x'), Cst(1))),
                      prog_facto,
                      BinaryPexp(And, EqualPAexp(Equal, Var('n'), Cst(0)), EqualPAexp(Equal, Var('x'), Cst(120)))
                 );;

(*1.4.5 Validite d'un triplet de Hoare *)
let htvalid_test(tpHoaret, list_valuation) =
  match tpHoaret with
  | HOARET(tprop1, prog, tprop2) ->
     if (pinterp(tprop1, list_valuation) = true)
     then
       if (pinterp(tprop2, (exec prog list_valuation)) = true)
       then true
       else false
     else false
;;

htvalid_test(tpHoare1, [('x', 2)]);;
htvalid_test(tpHoare2, [('x', 2)]);;
htvalid_test(tpHoare3, [('x', 2);('r', 4)]);;
htvalid_test(tpHoare4, [('n', 5);('x',1)]);;

let hoare_triple_to_string hoare_triple =
  match hoare_triple with
  | HOARET (propA, prog, propB) ->  prop_to_string propA ^ " " ^ prog_to_string prog ^ " " ^ prop_to_string propB
;;

(* 2.1.1 *)

type tconclusion =
| Hoare of hoare_triple
| Formule of tprop
;;

type tgoal = { 
  formule : (string * tprop) list; 
  conclusion : tconclusion
};;

let rec print_formule_list (formule : (string * tprop) list) : unit =
  if( formule != [])
  then
      match formule with
      | (s,f)::tl ->  print_formule_list tl;
                      print_endline (s ^" : "^ prop_to_string f)
      | [] -> failwith "Formule is empty"
;;

let tgoal_print goal =
  print_formule_list goal.formule;
  print_endline "================================";
  match goal.conclusion with
  | Hoare hoare     -> print_endline (hoare_triple_to_string hoare)
  | Formule formule -> print_endline (prop_to_string formule) 
;;

let rec tgoal_list_print (goal : tgoal list) =
  match goal with
  | hd::tl  ->  tgoal_print hd;
                print_endline "";
                tgoal_list_print tl; 
  | []      -> print_endline "\n"
;;



let fresh_ident =
  let prefix = "H" and count = ref 0
  in
  function () -> ( count := ! count + 1 ;
  prefix ^ ( string_of_int (! count )))
;;

let add_formule_goal (f : tprop) (g : tgoal) : tgoal =
  { formule = (fresh_ident(), f) :: g.formule  ; conclusion = g.conclusion}
;;

let create_goal (conc : tconclusion) : tgoal =
  { formule = [] ; conclusion = conc}
;;

let create_goal_with_formule form conc : tgoal =
  { formule = form ;  conclusion = conc}
;;

let goal1 = create_goal (Formule exp30);;
let goal2 = add_formule_goal exp30 goal1;;
tgoal_print goal2;;

(* 2.1.2 La rg???le de d???duction pour la boucle repeat ??? voir sur pdf *)

(* 2.1.3 Le langage des tactiques *)
(* Question 6 *)
type prop_tactics =
| And_Intro
| Or_Intro_1
| Or_Intro_2
| Impl_Intro
| Not_Intro 
| And_Elim_1  of string
| And_Elim_2  of string
| Or_Elim     of string
| Impl_Elim   of string * string
| Not_Elim    of string * string
| Assume      of tprop
| Exact       of string
| Admit
;;

type hoare_tactics =
| HSkip
| HAssign
| HIf
| HRepeat
| Hcons
| HSEq
;;

type ttactic =
| Prop_tactics of prop_tactics
| Hoare_Tactics of hoare_tactics
;;

(* 2.2 Appliquer une tactique ??? un but *)

(*Question 1*)
let rec bool2prop bexp =
  begin match bexp with
  | True -> TrueP
  | False -> FalseP
  | Neg(op, fd) -> NegP(Not, bool2prop(fd))
  | BinaryBexp(op, fg, fd) ->
     begin match op with
     | And -> BinaryPexp(And, bool2prop(fg), bool2prop(fd))
     | Or -> BinaryPexp(Or, bool2prop(fg), bool2prop(fd))
     end
  | EqualAexp(op, fg, fd) -> EqualPAexp(Equal, fg, fd)
  | InfEqAexp(op, fg, fd) -> InfPEqAexp(InfEqual, fg, fd)
  end
;;

(* Question 2 *)
let and_intro (goal : tgoal) =
  match goal.conclusion with
  | Hoare hoare     -> failwith "error : is a hoare expression"
  | Formule formule -> (
    match formule with
    | BinaryPexp (type_prop, tprop_1, tprop_2) -> (
      match type_prop with
      | Or  -> failwith "error : is a or expression"
      | And -> [ create_goal_with_formule goal.formule ( Formule tprop_1) ; create_goal_with_formule goal.formule ( Formule tprop_2 ) ]
    )
    | _             -> failwith "error : not a binari  expression"
  )
;;

let or_intro_1 (goal : tgoal) = 
  match goal.conclusion with
  | Hoare hoare     -> failwith "error : is a hoare expression"
  | Formule formule -> (
    match formule with
    | BinaryPexp (type_prop, tprop_1, tprop_2) -> (
      match type_prop with
      | Or  -> [ create_goal_with_formule goal.formule ( Formule tprop_1) ]
      | And -> failwith "error : is a and expression"
    )
    | _ -> failwith "error : not a binari  expression"
  )
;;

let or_intro_2 (goal : tgoal) = 
  match goal.conclusion with
  | Hoare hoare     -> failwith "error : is a hoare expression"
  | Formule formule -> (
    match formule with
    | BinaryPexp (type_prop, tprop_1, tprop_2) -> (
      match type_prop with
      | Or  -> [ create_goal_with_formule goal.formule ( Formule tprop_2) ]
      | And -> failwith "error : is a and expression"
    )
    | _ -> failwith "error : not a binari  expression"
  )
;;

let impl_intro (goal : tgoal) = 
  match goal.conclusion with
  | Hoare hoare     -> failwith "error : is a hoare expression"
  | Formule formule -> (
    match formule with
    | ImplPexp (type_prop, tprop_1, tprop_2) -> (
      match type_prop with
      | Implicit -> [  add_formule_goal tprop_1 (create_goal_with_formule goal.formule ( Formule tprop_2)) ]
    )
    | _ -> failwith "error : not a binari  expression"
  )
;;

let impl_intro (goal : tgoal) = 
  match goal.conclusion with
  | Hoare hoare     -> failwith "error : is a hoare expression"
  | Formule formule -> (
    match formule with
    | ImplPexp (type_prop, tprop_1, tprop_2) -> (
      match type_prop with
      | Implicit -> [  add_formule_goal tprop_1 (create_goal_with_formule goal.formule ( Formule tprop_2)) ]
    )
    | _ -> failwith "error : not a binari  expression"
  )
;;

let not_intro (goal : tgoal) = 
  match goal.conclusion with
  | Hoare hoare     -> failwith "error : is a hoare expression"
  | Formule formule -> (
    match formule with
    | NegP (type_prop, tprop) -> (
      match type_prop with
      | Not -> [  add_formule_goal tprop (create_goal_with_formule goal.formule ( Formule FalseP)) ]
    )
    | _ -> failwith "error : not a binari  expression"
  )
;;

let rec search_from_key (list : (string * tprop) list) (s : string) =
  match list with
  | (h,f)::tl ->
    if h = s
    then 0
    else search_from_key tl s + 1
  | _  -> failwith ("error search_from_key : not in list")
;;

let rec change_nth_formule (formules : (string * tprop) list) (prop : tprop)  (n : int) : (string * tprop) list=
  match formules with
  | (h, formprop):: tl ->
    if n = 0
    then (h, prop) :: tl
    else (h, formprop) :: (change_nth_formule formules prop (n-1))
  | _   -> []
;;

let and_elim_1 (goal : tgoal) (s : string) =
  let n = search_from_key goal.formule s in
  let (h , formule) = nth goal.formule n in
  match formule with
    | BinaryPexp (type_prop, tprop_1, tprop_2) -> (
      match type_prop with
      | Or  -> failwith "error : is a or expression"
      | And -> [add_formule_goal tprop_1 goal]
    )
    | _             -> failwith "error : not a binari  expression"
;;

let and_elim_2 (goal : tgoal) (s : string) =
  let n = search_from_key goal.formule s in
  let (h , formule) = nth goal.formule n in
  match formule with
  | BinaryPexp (type_prop, tprop_1, tprop_2) -> (
    match type_prop with
    | Or  -> failwith "error : is a or expression"
    | And -> [add_formule_goal tprop_2 goal]
  )
  | _             -> failwith "error : not a binari  expression"
;;

let or_elim (goal : tgoal) (s : string) =
  let n = search_from_key goal.formule s in
  let (h , formule) = nth goal.formule n in
  match formule with
  | BinaryPexp (type_prop, tprop_1, tprop_2) -> (
    match type_prop with
    | Or  -> 
      let newform = change_nth_formule goal.formule tprop_1 n in
      [create_goal_with_formule newform goal.conclusion ; create_goal_with_formule newform goal.conclusion]
    | And -> failwith "error : is a and expression"
  )
  | _             -> failwith "error : not a binari  expression"
;;

let impl_elim (goal : tgoal) (h1: string)  (h2: string) =
  let n1  = search_from_key goal.formule h1 and
      n2  = search_from_key goal.formule h2 in
  let (h1 , formule1)  = nth goal.formule n1 and
      (h2 , formule2)  = nth goal.formule n2 in
  match formule1 with
  |ImplPexp (type_prop, tprop_1, tprop_2) ->
    if(tprop_1 == formule2)
    then [add_formule_goal tprop_2 goal]
    else failwith "error impl_elim : left part of impl is no equal to the second form given"
  | _ -> failwith "error impl_elim : not a impl form"
;;

let not_elim (goal : tgoal) (h1: string)  (h2: string) =
  let n1  = search_from_key goal.formule h1 and
      n2  = search_from_key goal.formule h2 in
  let (h1 , formule1)  = nth goal.formule n1 and
      (h2 , formule2)  = nth goal.formule n2 in
  match formule1 with
  | NegP (type_prop, tprop) -> (
    match type_prop with
    | Not -> 
      if(tprop == formule2)
      then [add_formule_goal tprop goal]
      else failwith "error not_elim : left part of impl is no equal to the second form given"
  )
  | _ -> failwith "error not_elim : not a Neg expression"
;;

let assume (goal : tgoal) (prop : tprop) =
  let new_goal = add_formule_goal prop goal in
  [new_goal ; (create_goal_with_formule (goal.formule) (Formule prop))]
;;

let exact (goal : tgoal) (s : string) =
  let n = search_from_key goal.formule s in
  let (h , formule) = nth goal.formule n in
  match goal.conclusion with
  | Formule f -> (
    if(formule = f)
      then []
      else failwith "error exact : not equal"
  ) 
  | Hoare h   -> failwith "error exact : not a tprop"
;;

let admit goal =
  begin match goal.conclusion with
  | Hoare hoare -> failwith "Calling admit on an hoare conclusion"
  | Formule form ->
     begin match form with
     | EqualPAexp(op, fg, fd) -> []
     | _ -> failwith "Calling admit on a tprop that is not EqualPAexp"
     end
  end
;;
  
let hskip goal tprop1 prog tprop2 list_valuation =
  begin match prog with
  | Skip -> if(pinterp(tprop1, list_valuation))
            then
              if pinterp(tprop2, list_valuation)
              then []
              else failwith "PostCondition is false in HISK"
            else failwith "Precondition is false in HSKIP"
  | _ -> failwith "Prog skip not found in HSKIP"
  end
;;

(* De (p) if b then c1 else c2 (Q) on trouve 2 triple de hoare en + -> (P /\ b) c1 (Q)    (P/\ non(b))c2(Q)*)
let hif goal tprop1 prog tprop2 list_valuation =
  begin match prog with
  | Condition(c1, bexp, c2, prog1, c3, prog2) ->
     let pb, pnb = (pinterp(tprop1, list_valuation) && binterp(bexp, list_valuation)), (pinterp(tprop1, list_valuation) && binterp(Neg(Not, bexp), list_valuation)) in
     let qc1, qc2 = pinterp(tprop2, (exec prog1 list_valuation)), pinterp(tprop2, (exec prog2 list_valuation)) in
     if(pb && qc1) && (pnb && qc2) 
     then let tpropPB, tpropNPB = BinaryPexp(And, tprop1, bool2prop(bexp)), BinaryPexp(And, tprop2, bool2prop(Neg(Not, bexp))) in
            [create_goal_with_formule ([(prop_to_string tpropPB, tpropPB);(prop_to_string tprop2, tprop2)]) (Hoare(HOARET(tpropPB, prog1, tprop2)));
           create_goal_with_formule ([(prop_to_string tpropNPB, tpropNPB);(prop_to_string tprop2, tprop2)]) (Hoare(HOARET(tpropNPB, prog2, tprop2)))]
     else failwith "Invalid Hoare in HIF"
  | _ -> failwith "Prog condition not found in HIF command"
  end
;;

let hassign goal tprop1 prog tprop2 list_valuation =
  begin match prog with
  | Skip -> if(pinterp(tprop1, list_valuation))
            then
              if pinterp(tprop2, (exec prog list_valuation))
              then []
              else failwith "PostCondition is false in HASSIGN"
            else failwith "Precondition is false in HASSIGN"
  | _ -> failwith "Prog skip not found in HASSIGN"
  end
;;

(* La logique d'une boucle est si (I)while b do c(I /\ Not(b)) devient (I/\b)c(I)
Dans un repeat cela nous donne (I)repeat x do c od(I /\ x = 0) devient (I /\ x > 0)c(I) soucis on a pas de >, cel devient donc (I /\ Not(x = 0))c(I)
 *)
let hrepeat goal tprop1 prog tprop2 list_valuation =
    begin match prog with
  | Repeat(loop, aexp, loop2, prog, loop3) ->
     if(pinterp(tprop1, list_valuation) && binterp(InfEqAexp(InfEqual, aexp, Cst(0)), list_valuation))
     then
       if pinterp(tprop2, (exec prog list_valuation))
       then let newTprop = BinaryPexp(And, tprop2, NegP(Not, EqualPAexp(Equal, Cst(ainterp(aexp, list_valuation)), Cst(0)))) in
         [create_goal_with_formule ([(prop_to_string newTprop, newTprop);(prop_to_string tprop2, tprop2)]) (Hoare(HOARET(newTprop, prog, tprop1)))]
       else failwith "PostCondition is false in HREPEAT"
     else failwith "Preconfition is false in HREPEAT"
  | _ -> failwith "Prog Repeat not found in HREPEAT command"
  end
;;

let hcons goal tprop1 prog tprop2 list_valuation =
  if(pinterp(tprop1, list_valuation))
  then
    if pinterp(tprop2, (exec prog list_valuation))
    then []
    else failwith "PostCondition is false in HCONS"
  else failwith "Preconfition is false in HCONS"
;;

(*On cr???e un Q qui sera True*)
let hseq goal tprop1 prog tprop2 list_valuation =
    begin match prog with
    | Seq(p1, p2) ->
       if(pinterp(tprop1, list_valuation))
       then
         if pinterp(tprop2, (exec prog list_valuation))
          then [create_goal_with_formule ([(prop_to_string tprop1, tprop1);(prop_to_string TrueP, TrueP)]) (Hoare(HOARET(tprop1, p1, TrueP)));
           create_goal_with_formule ([(prop_to_string TrueP, TrueP);(prop_to_string tprop2, tprop2)]) (Hoare(HOARET(TrueP, p2, tprop2)))]
         else failwith "PostCondition is false in P /\ b in HIF"
       else failwith "Preconfition is false in HSEQ"  
  | _ -> failwith "Prog Seq not found in HSEQ command"
  end
;;


let rec apply_hoare_tactic (goal : tgoal) (tactic : ttactic) list_valuation = (
  begin match tactic with
  | Hoare_Tactics hoare ->
     begin match goal.conclusion with
     | Hoare(ht) ->
        begin match ht with
        | HOARET(t1, p, t2) ->
           begin match hoare with
           | HSkip   -> hskip goal t1 p t2 list_valuation
           | HAssign -> hassign goal t1 p t2 list_valuation
           | HIf     -> hif goal t1 p t2 list_valuation
           | HRepeat -> hrepeat goal t1 p t2 list_valuation
           | Hcons   -> hcons goal t1 p t2 list_valuation
           | HSEq    -> hseq goal t1 p t2 list_valuation
           end
        end
     | Formule(f) -> failwith "Conclusion must be an Hoare triple"
     end
  | Prop_tactics intro -> apply_prop_tactic goal tactic list_valuation
  end
)
and apply_prop_tactic (goal : tgoal) (tactic : ttactic) list_valuation =
  match tactic with
  | Prop_tactics prop -> (
    match prop with
    | And_Intro         ->  and_intro   goal
    | Or_Intro_1        ->  or_intro_1  goal
    | Or_Intro_2        ->  or_intro_2  goal
    | Impl_Intro        ->  impl_intro  goal
    | Not_Intro         ->  not_intro   goal
    | And_Elim_1 h1     ->  and_elim_1  goal h1
    | And_Elim_2 h1     ->  and_elim_2  goal h1
    | Or_Elim    h1     ->  or_elim     goal h1
    | Impl_Elim  (h1,h2)->  impl_elim   goal h1 h2
    | Not_Elim   (h1,h2)->  not_elim    goal h1 h2
    | Assume     prop   ->  assume      goal prop
    | Exact      h1     ->  exact       goal h1
    | Admit             ->  admit goal
  )
  |  Hoare_Tactics hoare -> apply_hoare_tactic goal tactic list_valuation
;;

let apply_tactic (goal : tgoal) (tactic : ttactic) list_valuation =
  match tactic with
  | Prop_tactics prop -> apply_prop_tactic goal tactic list_valuation
  | Hoare_Tactics hoare -> apply_hoare_tactic goal tactic list_valuation
;;

let apply_tactic_goal_list (goal : tgoal list) (tactic : ttactic) list_valuation =
  match goal with
  | hd :: tl -> (apply_tactic hd tactic list_valuation)@ tl
  | [] -> []
  ;;

(* 2.2.1 La logique des propositions*)
(* Question 3*)

(*(P ??? Q ??? R) ??? (P ??? R) ??? (Q ??? R)*)
let q3_P = InfPEqAexp(InfEqual, Var('x'), Cst(100));;
let q3_Q = BinaryPexp(Or, EqualPAexp(Equal, Var('y'), Var('x')), EqualPAexp(Equal, Var('y'), Cst(100)));;
let q3_R = InfPEqAexp(InfEqual, Var('x'), Var('y'));;


let q3_left_part  = ImplPexp(Implicit, (BinaryPexp(Or, q3_P, q3_Q)), q3_R);;
let q3_right_part = BinaryPexp(And, ImplPexp(Implicit, q3_P, q3_R), ImplPexp(Implicit, q3_Q, q3_R) );;
let q3_final      = ImplPexp(Implicit, q3_left_part, q3_right_part);;


(*
Impl_Intro.
And_Intro.
Impl_Intro.
assume (P \/ Q).
Impl_Elim in H and H1.
exact H2.
Or_Intro_1.
exact H0.
Impl_Intro.
assume (P \/ Q).
Impl_Elim in H and H1.
exact H2.
Or_Intro_2.
exact H0.
*)

let q3_goal       = [create_goal (Formule q3_final)];;
print_endline "\t\t** q3_goal **";;
tgoal_list_print q3_goal;;
let q3_goal2 = apply_tactic_goal_list q3_goal (Prop_tactics(Impl_Intro)) [];;
print_endline "\t\t** q3_goal2 **";;
tgoal_list_print q3_goal2;;
let q3_goal3 = apply_tactic_goal_list q3_goal2 (Prop_tactics(And_Intro)) [];;
print_endline "\t\t** q3_goal3 **";;
tgoal_list_print q3_goal3;;
let q3_goal4 = apply_tactic_goal_list q3_goal3 (Prop_tactics(Impl_Intro)) [];;
print_endline "\t\t** q3_goal4 **";;
tgoal_list_print q3_goal4;;
let q3_goal5 = apply_tactic_goal_list q3_goal4 (Prop_tactics(Assume (BinaryPexp(Or, q3_P, q3_Q)))) [];;
print_endline "\t\t** q3_goal5 **";;
tgoal_list_print q3_goal5;;
let q3_goal6 = apply_tactic_goal_list q3_goal5 (Prop_tactics(Impl_Elim ("H2","H4"))) [];;
print_endline "\t\t** q3_goal6 **";;
tgoal_list_print q3_goal6;;
let q3_goal7 = apply_tactic_goal_list q3_goal6 (Prop_tactics(Exact "H5")) [];;
print_endline "\t\t** q3_goal7 **";;
tgoal_list_print q3_goal7;;
let q3_goal8 = apply_tactic_goal_list q3_goal7 (Prop_tactics(Or_Intro_1)) [];;
print_endline "\t\t** q3_goal8 **";;
tgoal_list_print q3_goal8;;
let q3_goal9 = apply_tactic_goal_list q3_goal8 (Prop_tactics(Exact "H3")) [];;
print_endline "\t\t** q3_goal9 **";;
tgoal_list_print q3_goal9;;
let q3_goal10 = apply_tactic_goal_list q3_goal9 (Prop_tactics(Impl_Intro)) [];;
print_endline "\t\t** q3_goal10 **";;
tgoal_list_print q3_goal10;;
let q3_goal11 = apply_tactic_goal_list q3_goal10 (Prop_tactics(Assume (BinaryPexp(Or, q3_P, q3_Q)))) [];;
print_endline "\t\t** q3_goal11 **";;
tgoal_list_print q3_goal11;;
let q3_goal12 = apply_tactic_goal_list q3_goal11 (Prop_tactics(Impl_Elim ("H2","H7"))) [];;
print_endline "\t\t** q3_goal12 **";;
tgoal_list_print q3_goal12;;
let q3_goal13 = apply_tactic_goal_list q3_goal12 (Prop_tactics(Exact "H8")) [];;
print_endline "\t\t** q3_goal13 **";;
tgoal_list_print q3_goal13;;
let q3_goal14 = apply_tactic_goal_list q3_goal13 (Prop_tactics(Or_Intro_2)) [];;
print_endline "\t\t** q3_goal14 **";;
tgoal_list_print q3_goal14;;
let q3_goal15 = apply_tactic_goal_list q3_goal14 (Prop_tactics(Exact "H6")) [];;
print_endline "\t\t** q3_goal15 **";;
tgoal_list_print q3_goal15;;

(* 2.2.2 La logique de Hoare*)
(* Question 4*)
let tHoare1 = HOARET(EqualPAexp(Equal, Var('x'), Cst(2)), Skip, EqualPAexp(Equal, Var('x'), Cst(2)));;
let tHoare2 = HOARET(InfPEqAexp(InfEqual, Binary(Add, Var('y'),Cst(1)), Cst(4)), Affect(Var('y'), AFFECT, Binary(Add, Var('y'), Cst(1))), InfPEqAexp(InfEqual, Var('y'), Cst(4)));;
let tHoare3 = HOARET(EqualPAexp(Equal, Var('y'), Cst(5)), Affect(Var('x'), AFFECT, Binary(Add, Var('y'), Cst(1))), EqualPAexp(Equal, Var('x'), Cst(6)));;
let tHoare4 = HOARET(TrueP, Seq(Seq(
                                    Affect(Var('z'), AFFECT, Var('x')),
                                    Affect(Var('z'), AFFECT, Binary(Add, Var('z'), Var('y')))),
                                Affect(Var('u'), AFFECT, Var('z'))),
                EqualPAexp(Equal, Var('y'), Binary(Add, Var('x'), Var('y'))));;
let tHoare5 = HOARET(TrueP, Condition(IF, InfEqAexp(InfEqual, Var('v'), Cst(0)), THEN, Affect(Var('r'), AFFECT, Binary(Add, Cst(0), Var('v'))), ELSE, Affect(Var('r'), AFFECT, Var('v'))), InfPEqAexp(InfEqual, Cst(0), Var('r')));;
let tHoare6 = HOARET(EqualPAexp(Equal, Var('x'), Var('y')),
                     Repeat(REPEAT, Cst(10), DO, Affect(Var('x'), AFFECT, Binary(Add, Var('x'), Cst(1))), OD),
                     EqualPAexp(Equal, Var('x'), Binary(Add, Var('y'), Cst(10))));;

(*Question 5*)
htvalid_test(tHoare1, [('x', 2)]);;
htvalid_test(tHoare2, [('y', 2)]);;
htvalid_test(tHoare3, [('x', 0);('y', 5)]);;
htvalid_test(tHoare4, [('x', 5);('y',1);]);;

htvalid_test(tHoare5, [('v', 0)]);;
htvalid_test(tHoare5, [('v', 1)]);;

htvalid_test(tHoare6, [('x', 5);('y',5)]);;
