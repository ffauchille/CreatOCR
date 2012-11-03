let get_dims img =
    ((Sdlvideo.surface_info img).Sdlvideo.w,
    (Sdlvideo.surface_info img).Sdlvideo.h)

let sdl_init () =
    begin
        Sdl.init [`EVERYTHING];
        Sdlevent.enable_events Sdlevent.all_events_mask;
    end

let load_img str = Sdlloader.load_image str

let y_template = 200
let x_template = 200

let redims img (x, y) = Sdlvideo.save_BMP img "tmp.bmp";
let cmd = "convert tmp.bmp -resize " ^ (string_of_int x) ^ "x" ^
(string_of_int y) ^ "\\! tmp.png" in
ignore (Unix.system cmd);
load_img "tmp.png"

(*Fonction test si un pixel est completement blanc*)
let white_pixel img x y = let (r,g,b) = Sdlvideo.get_pixel_color img x y in
    (r + g + b > 750)
