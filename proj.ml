(* Dimensions d'une image *)
let get_dims img =
  ((Sdlvideo.surface_info img).Sdlvideo.w, (Sdlvideo.surface_info
					      img).Sdlvideo.h) 
(* init de SDL *)
let sdl_init () =
  begin
    Sdl.init [`EVERYTHING];
    Sdlevent.enable_events Sdlevent.all_events_mask;
  end
    
(* attendre une touche ... *)
let rec wait_key () =
  let e = Sdlevent.wait_event () in
    match e with
	Sdlevent.KEYDOWN _ -> ()
      | _ -> wait_key ()
       
(*
  show img dst
  affiche la surface img sur la surface de destination dst
  (normalement l'écran)
*)
let show img dst =
  let d = Sdlvideo.display_format img in
    Sdlvideo.blit_surface d dst ();
    Sdlvideo.flip dst
 
(* level *)
let level (r,g,b) = 
  0.3 *. (float)r +. 0.59 *. (float)g +. 0.11 *. (float)b
    
(*  image2grey *)
let color2grey (r,g,b) =
  let moyenne = int_of_float(level(r,g,b)) in
    (moyenne, moyenne, moyenne)

let mix_color (r,g,b) = (* determine si un pixel doit être en noir ou blanc*)
  if r > 50 then 
    (250, 250 ,250)
  else 
    (0, 0, 0)

let image2grey src dst = 
  Sdlvideo.lock src;
  let (w,h) = get_dims src in 
    for y=0 to h-1 do
      for x=0 to w-1 do
	Sdlvideo.put_pixel_color dst (x+150) (y+150)
	  (mix_color(color2grey(Sdlvideo.get_pixel_color src x y)))
      done
    done  

let xu = ref 0;;(*coord du 1er pixel haut*)
let yu = ref 0;;

let xd = ref 0;;(*coord du plus bas*)
let yd = ref 0;;

let ab = ref 0.;; (*distance entre les deux points*)
let ac = ref 0.;; (*distance du coté adjacent*) 

let alpha = ref 0.;;(*valeur de l'angle de rotation*)
let pi = 4.4 *. atan 1.0;;(* pi *)
 
(*trouve les coord du point bas pour penché à gauche*)      
let from_down_left src =
  let (w,h) = get_dims src in 
  let x = ref 0 in
  let y = ref (h-1) in
  while !y > 0  do
    while !x < w do
      let (r1,g1,b1) = Sdlvideo.get_pixel_color src !x !y in
      if r1 = 0 then
	begin
	  xd := !x;
	  yd := !y;
	  x := (w+1);
	  y := -1
	end
      else
	incr x;
    done;
    x := 0;
    decr y;
  done;;

let from_up_left src =
  let (w,h) = get_dims src in 
  let x = ref 0 in
  let y = ref 0 in
  while !x < w do
    while !y < h do
      let (r1,g1,b1) = Sdlvideo.get_pixel_color src !x !y in
      if r1 = 0 then
	begin
	  xu := !x;
	  yu := !y;
	  x := w;
	  y := h+1
	end
      else
	incr y;
    done;
    y := 0;
    incr x;
  done;;

(*determine la distance entre les deux points*)
let dist ab xu xd yu yd=
  ab := sqrt((float)(((!xd)-(!xu))*((!xd)-(!xu))+((!yd)-(!yu))*((!yd)-(!yu))))
  
(*determine la distance du coté adjacent*)
let height ac yd yu=
  ac := (float)((!yd)-(!yu))

(*determine l'angle de rotation*)
let angle ab ac alpha pi= 
  alpha := (180.*.((acos(((!ac)/.(!ab))))/.pi))(*angle en degré*)
  (*alpha := acos((!ac)/.(!ab))  *)                    (*angle en radian*)

(*une meileur conversion des float en int*)
let conv a = 
  if a -. (float)(int_of_float a) < 0.5 then
    int_of_float a
  else
    (int_of_float a) +1
  
(* crée une matrice contenant l'image*)     
let cree_t src dst = 
  let (w,h) = get_dims src in 
  let table = Array.make_matrix w h (0,0,0) in
    for i=0 to w-1 do
      for h = 0 to h-1 do
	table.(i).(h)<- Sdlvideo.get_pixel_color dst (i+150) (h+150);
	Sdlvideo.put_pixel_color dst (i+150) (h+150) (0,0,0);
      done;
    done;
  table;;
 
(*effectue la rotation *)
let moov src dst alpha =
  let (w,h) = get_dims src in 
  let tab = cree_t src dst in
  for y=0 to h-1 do
    for x=0 to w-1 do
      begin
	let x_new =(int_of_float(((float)(x-(w/2)))*.cos(!alpha) +.
				   ((float)(y-(h/2)))*.sin(!alpha)))+(w/2) in
	let y_new =(int_of_float(((float)(x-(w/2)))*.(-1.)*.sin(!alpha) +.
				   ((float)(y-(h/2)))*.cos(!alpha)))+(h/2) in
	Sdlvideo.put_pixel_color dst (x_new+150) (y_new+150) tab.(x).(y)
      end
    done
  done 

let cl_pic dst = 
  let table = Array.make_matrix 900 900 (0,0,0) in
  for x=0 to 899 do
    for y=0 to 899 do
     	table.(x).(y)<- Sdlvideo.get_pixel_color dst x y;
    done;
  done;
  table

let clean_pic dst =
  let tab = cl_pic dst in
  for x=1 to 898 do
    for y=1 to 898 do
      let (r,g,b)=tab.(x).(y) in
      let (r1,g1,b1)=tab.(x+1).(y) in
      let (r2,g2,b2)=tab.(x-1).(y) in
      let (r3,g3,b3)=tab.(x).(y+1) in
      let (r4,g4,b4)=tab.(x).(y-1) in
      if ((r=0 && g=0 && b=0)&&((r1=255 && g1=255 && b1= 255)||(r2=255 && g2=255 && b2= 255)||(r3=255 && g3=255 && b3= 255)||(r4=255 && g4=255 && b4= 255))) then
	begin
	  Sdlvideo.put_pixel_color dst x y (255,255,255);
	  print_int 32
	end
    done
  done
  	
(* rotation de 90degré sens trigo*)
let rot90 src dst =
  let (w,h) = get_dims src in 
  let tab = cree_t src dst in
  let tabF = Array.make_matrix h w (0,0,0) in
  let x2 = ref 0 in
  let y2 = ref (h-1) in
  for x=0 to h-1 do
    for y=0 to w-1 do
      tabF.(x).(y) <- tab.(!x2).(!y2);
      Sdlvideo.put_pixel_color dst (x+150) (y+150) tabF.(x).(y);
      incr x2;
    done;
    x2 :=0;
    decr y2;
  done 

(* rotation de 270 degré sens trigo*)
let rot270 src dst = 
  let (w,h) = get_dims src in 
  let tab = cree_t src dst in
  let tabF = Array.make_matrix h w (0,0,0) in
  let x2 = ref (w-1) in
  let y2 = ref (h-1) in
  for x=0 to h-1 do
    for y=0 to w-1 do
      tabF.(x).(y) <- tab.(!x2).(!y2);
      Sdlvideo.put_pixel_color dst (x+150) (y+150) tabF.(x).(y);
      decr x2;
    done;
    x2 :=(w-1);
    decr y2;
  done 

(* main *)
let main () =
  begin
    (* Nous voulons 1 argument *)
    if Array.length (Sys.argv) < 2 then
      failwith "Il manque le nom du fichier!";
    (* Initialisation de SDL *)
    sdl_init ();
    (* Chargement d'une image *)
    let img = Sdlloader.load_image Sys.argv.(1) in
    (* On récupère les dimensions *)
   (* let (w,h) = get_dims img in*)
    (* On crée la surface d'affichage en doublebuffering *)
    let display = Sdlvideo.set_video_mode 900 900 [`DOUBLEBUF] in
    (* on transforme l'image *)
    let dst = Sdlvideo.create_RGB_surface_format img [] 900 900 in
    wait_key ();
    image2grey img dst;
    show dst display;
    wait_key ();
    from_down_left img; (* acquiert les coord des deux points*)
    from_up_left img;
    dist ab xu xd yu yd; (*calcul les distances et l'angles *)
    height ac yd yu;
    angle ab ac alpha pi;
    moov img dst alpha ;
    show dst display;
    wait_key ();
    clean_pic dst;
    wait_key ();
    exit 0
  end
    
let _ = main ()   
