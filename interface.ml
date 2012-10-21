(* init de SDL *)
let sdl_init () =
  begin
    Sdl.init [`EVERYTHING];
    Sdlevent.enable_events Sdlevent.all_events_mask;
  end
let _ = GMain.init ()

let width = ref 800
let height = ref 600
let filenameimage = ref "" 

(* Chargement d'une image *)

let load_picture = Sdlloader.load_image


(* Ouverture de la fenêtre *)

let window = GWindow.window
	~title:"CreatOCR"
	~resizable:true
	~height:!height
	~width:!height ()

(* Permettre l'ajout de widgets dans "window" *)

let vbox = GPack.vbox
	~border_width:1
	~height:((!height)/3)
	~width:((!width)/3)
	~packing:window#add ()

let frame_image = GBin.frame
	~label:"Image selectionnée"
	~width((!width)/10)
	~packing:vbox#add ()
let image = GMisc.image
	~file:!filenameimage
	~packing:frame_image#add ()

let main () =
	begin 
		Sdl.init [`EVERYTHING];
		window#show ();
		GMain.Main.main()
	end
let _ = main ()
