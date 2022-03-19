type t_hoare_triplet = {
    h_value : string
};;

type t_formule = {
    f_value : string
};;

type t_conclusion = 
  Hoare of t_hoare_triplet
| Formule of t_formule
;;

type t_goal = { 
    formule : (string * t_formule) list; 
    conclusion : t_conclusion
};;

let create_goal (a : t_conclusion) : t_goal =
    { formule = [] ; conclusion = a}
;;


let fresh_ident =
    let prefix = " H " and count = ref 0
    in
    function () -> ( count := ! count + 1 ;
    prefix ^ ( string_of_int (! count )))
;;    

let add_formule_goal_string (s : string) (g : t_goal) : t_goal =
    { formule = (fresh_ident(), {f_value = s}) :: g.formule  ; conclusion = g.conclusion}
;;

let add_formule_goal (f : t_formule) (g : t_goal) : t_goal =
    { formule = (fresh_ident(), f) :: g.formule  ; conclusion = g.conclusion}
;;

let rec print_formule_list (formule : (string * t_formule) list) : unit =
    if( formule != [])
    then
        match formule with
        | (s,f)::tl ->  print_formule_list tl;
                        print_endline (s ^" : "^ f.f_value)
;;

let print_conclusion(conclusion : t_conclusion) : unit =
    match conclusion with
    | Hoare  h    ->  print_endline h.h_value
    | Formule  f  ->  print_endline f.f_value
;;

let print_goal (g :t_goal) : unit = 
    print_formule_list g.formule;
    print_endline "==========================";
    print_conclusion g.conclusion
;;

let conc : t_conclusion = Hoare {h_value = "P \\/ Q"};;
let goal = create_goal(conc );;
let goal2 = add_formule_goal_string "P" (add_formule_goal_string "(P \\/ Q => R)" goal);;
print_goal goal2;
    