type cell = { surf:Sdlvideo.surface ; value:string }

let is_same n (r1, g1, b1) (r2, g2, b2) =
    ((r1 - r2 < n) && (b1 - b2 < n) && (g1 - g2 < n))

let comp2img src dst = let (w, h) = Tools.get_dims src and e = ref 0
in for y = 0 to (h - 1) do
    for x = 0 to (w - 1) do
        if (is_same 2 (Sdlvideo.get_pixel_color src x y)
        (Sdlvideo.get_pixel_color dst x y))
        then ()
        else e := !e + 1
    done
done;
((float) !e) /. (float (w * h))

let sum_up ltab img = let rec sum_loop img (best_l, mini) = function
    | [] -> best_l
    | e::q -> let pmini = ref mini and pbest_l = ref best_l in
    for i=0 to (Array.length e - 1) do
        let pe = comp2img img (e.(i).surf) in
        if (pe < mini) then
            (pmini := pe;
             pbest_l := e.(i).value)
        else ()
    done;
    sum_loop img (!pbest_l, !pmini) q
in sum_loop img ("", 0.) ltab
