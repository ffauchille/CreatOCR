(* chars  recode*)

type char =
    {
        x:int;
        y:int;
        height:int;
        width:int;
        value:string;
        double:bool;
    }

    (* fonction  check colonne full blanc *)
    (*ADD DEBUG*)
let rec white_column img coox cooy cooy_max =
    if (cooy == cooy_max)
    then (Tools.white_pixel img coox cooy)
    else (
        if (Tools.white_pixel img coox cooy)
        then white_column img coox (cooy + 1) cooy_max
        else (false)
        )


(* fonction decoupe les char ET fait la diff des doubles  char*)
let make_char img coox_min cooy_min cooy_max coox_max =
    let coox_cur = ref coox_min in
    while ((!coox_cur <  coox_max) &&  not(white_column img !coox_cur
    cooy_min cooy_max)) do
        coox_cur := !coox_cur + 1
    done;
    if ((float)(!coox_cur-coox_min)<=((0.90) *. (float)(cooy_max-cooy_min)))
    then (
    {x=coox_min ; y=cooy_min ; height=cooy_max ; width=(!coox_cur -
    coox_min) ; value="" ; double=false })
        else (
        {x=coox_min ; y=cooy_min ; height=cooy_max ; width=(!coox_cur -
        coox_min) ; value="" ; double=true })

(*
(*Fonction qui chope la ligne basse *)
let get_ligne_basse img coox cooy cooy_max coox_max=
    let nb_pn_max = ref 0 and nb_pn = ref 0 and l_m = ref cooy
                   and ref_cooy = cooy  and ref_coox = ref coox in
    while (!ref_cooy <= cooy_max) do
        while (!ref_coox <= coox_max)do
            if (not(Tools.white_pixel img !ref_coox !ref_cooy))
                then nb_pn := !nb_pn +1
            ref_coox := !ref_coox + 1
        done;
        if (!nb_pn >= !nb_pn_max)
        then (nb_pn_max := !nb_pn)
        if ((float)(!nb_pn) > ((0.5) *.(float)(nb_pn_max)))
        then (l_m := !ref_cooy)
        nb_pn := 0;
        ref_coox := 0;
        ref_cooy := !ref_cooy + 1
    done;
    l_m


(* ATTENTION AU NIVEAU DE L'APPEL COOY ET COOY_MIN SONT LES MEME
 * mais cooy change au fur et a mesure des appel recu *)
let rec white_column img coox cooy cooy_min l_m =
    if (cooy == (l_m - 1))
        then (Tools.white_pixel img coox cooy)
    else (
            if (Tools.white_pixel img coox cooy)
                then white_column img coox (cooy+1) cooy_max l_m
            else ( if(((float)(l_m - cooy) > ((float)(l_m - cooy_min) /. 2.) )
            && (Tools.white_pixel img (coox-1) cooy)
            && (Tools.white_pixel img (coox+1) cooy))
                        then (white_column img coox (cooy+1) cooy_max l_m)
                    else (false)
                 )
*)

let reverse lt = let rec rev acu = function
    |[] -> acu
    |e::q -> rev (e::acu) q in rev [] lt

(* Fonction qui va appeler make-char et donne la coord de fin de char*)
let cut_tmp img coox cooy cooy_max coox_max =
    let ch = make_char img coox cooy cooy_max coox_max in
    ((ch.width + coox), ch)


let rec cut_chars img line_cur list_c nb_c = function
    | coox_cur when (coox_cur == line_cur.Line.width) -> (list_c, nb_c)
    | coox_cur -> if (white_column img coox_cur line_cur.Line.y (line_cur.Line.y
    + line_cur.Line.height))
    then cut_chars img line_cur list_c nb_c (coox_cur +1)
    else (let (coox_end_c, ch) =
        cut_tmp img coox_cur line_cur.Line.y (line_cur.Line.y +
        line_cur.Line.height) line_cur.Line.width
    in cut_chars img line_cur (ch::list_c) (nb_c + (if (ch.double) then
    2 else 1)) coox_end_c)


let nb_chars img list_l =
    let rec cut_count img nb_c list_c = function
        | []   -> (list_c, nb_c)
        | a::list_l ->
            let (list_c_tmp, nb_c_tmp) = cut_chars img a list_c 0 a.Line.x in
                cut_count img (nb_c + nb_c_tmp) (list_c@list_c_tmp) list_l
                in cut_count img 0 [] list_l


let main img =
 let (dimx,dimy) = Tools.get_dims img in
 let (list_l, nb_l) = Line.nbLines img 0 0 (dimx-1) in
 let (list_c, nb_c) = nb_chars img (reverse list_l) in
 Printf.printf ("RESULTAT FINAL :\n Nombre de lignes : %d;
 Nombre de caracteres : %d;\n") nb_l nb_c

let main12 path = Tools.sdl_init();
main (Tools.load_img path)

let _ = main12 Sys.argv.(1) ; exit 0

