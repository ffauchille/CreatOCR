(* Type line est une ligne de caractere*)
type line =
    {
    x:int;      (* x de depart*)
    y:int;      (*y en haut a gauche de la ligne de carac*)
    height:int; (*epaisseur de la ligne*)
    width:int;  (*largeur/ x de fin de la ligne *)
    }

(*Fonction test si une ligne de pixel est completment blanche*)
let white_pixel_line1 img x y width =
    let x1 = ref x and iw = ref true in
    while ((!x1 < width) && (!iw)) do
        iw := Tools.white_pixel img (!x1) y;
        x1 := !x1 + 1
    done;
    (!iw)

(*Fonction qui definie les line // check les hauteurs des line*)
let black_lines img x y width ymax = let y1 = ref y in
    while ((!y1 < ymax) && not(white_pixel_line1 img x !y1 width)) do
        y1 := !y1 + 1
    done;
    { x=x ; y=y ; height=(!y1 - y) ; width=(width - x) }

(*Fonction  qui appel blacl_lines et defini le y de sortie *)
let tmp_cut1 img x y width ymax =
    let r = black_lines img x y width ymax in
    ((r.height + y), r)

(*Fonction  de parcours de l'image qui gere l'appel des autres fonctions*)
let nbLines img start_x start_y width = let (w,h) = Tools.get_dims img in
    let rec cutAndCount width nb l1 coord_x = function
        |y when (y == (h - 1)) -> (l1, nb)
        |y -> if (white_pixel_line1 img coord_x y width) then
            cutAndCount width nb l1 coord_x (y + 1) else
            (let (y1,nl) = tmp_cut1 img coord_x y width h in
            cutAndCount width (nb + 1) (nl::l1) coord_x y1)
    in cutAndCount width 0 [] start_x start_y


let rec print_lines = function
    |[] -> ()
    |e::q ->
Printf.printf ("x haut : %03d ; y haut : %03d ; hauteur : %03d ; largeur : %03d\n")
    e.x e.y e.height e.width;
    print_lines q

