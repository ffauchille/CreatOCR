(* init de SDL *)
let sdl_init () =
  begin
    Sdl.init [`EVERYTHING];
    Sdlevent.enable_events Sdlevent.all_events_mask;
  end
let _ = GMain.init ()

let width = ref 800
let height = ref 600
let filenameimage = ref "pic.jpg" 
(* attendre une touche ... *)
let rec wait_key () =
  let e = Sdlevent.wait_event () in
    match e with
    Sdlevent.KEYDOWN _ -> ()
      | _ -> wait_key ()

(* Chargement d'une image *)

let load_picture = Sdlloader.load_image

(* Ouverture de la fenêtre *)
let sw foo = ()
let window = GWindow.window
	~title:"CreatOCR"
	~resizable:true
	~height:!height
	~width:!width()

(* Permettre l'ajout de widgets dans "window" *)

let vbox = GPack.vbox
	~border_width:1
	~height:((!height)/3)
	~width:((!width)/3)
	~packing:window#add ()
let hbox = GPack.hbox
	~border_width:2
	~height:(2*(!height)/3)
	~width:(2*(!width)/3)
	~packing:vbox#add ()
let bbox = GPack.button_box `VERTICAL
	~layout:`SPREAD
	~packing:(hbox#pack ~expand:false) ()

let frame_image = GBin.frame
	~label:"Image selectionnée"
	~width:((!width)/10)
	~packing:vbox#add ()

let image = GMisc.image
	~file:!filenameimage
	~packing:frame_image#add ()
(*En attente des fonctions *)
let rot_msg () = print_endline "Rotation"
	(*let dlg _= GWindow.message_dialog
		~message:"Fonction de remise à droit de l'image"
		~destroy_with_parent:false
		~use_markup:true
		~message_type:`QUESTION
		~position:`CENTER_ON_PARENT
		~buttons:GWindow.Buttons.yes_no () in
	let res = dlg#run () = `NO in
	dlg#destroy ();
	res*)
let nb_l ()= print_endline "Fonction qui renvoie le nombre ligne du texte de l'image"
let nb () = print_endline "Fonction qui met transforme l'image au niveau gris"
(* Boutons *)
let button1 = 
	let button = GButton.button
	~label:"Rotation"
	~packing:bbox#add () in
 	sw(button#connect#clicked ~callback:rot_msg);
	button
let button2 =
	let button = GButton.button
		~label:"Nbr de lignes"
		~packing:bbox#add () in
	sw(button#connect#clicked ~callback:nb_l);
	button
let button3 = 
	let button = GButton.button
		~label:"Noir et blanc"
		~packing:bbox#add () in
	sw(button#connect#clicked ~callback:nb);
	button

let quit = 
	let button = GButton.button
		~stock:`QUIT
		~packing:bbox#add () in
	sw(button#connect#clicked ~callback:GMain.quit);
	button

let main () =
	begin 
		Sdl.init [`EVERYTHING];
		window#show ();
		GMain.Main.main ()
	end
let _ = main ()
