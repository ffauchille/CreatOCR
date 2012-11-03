# TP sdl
 
OCAML=ocamlopt
OCAMLFLAGS= -I +sdl -I +lablgtk2 
OCAMLLD= bigarray.cmxa sdl.cmxa sdlloader.cmxa lablgtk.cmxa gtkInit.cmx
 
interface: interface.ml
	${OCAML} ${OCAMLFLAGS} ${OCAMLLD} -o interface interface.ml
 
clean::
	rm -f *~ *.o *.cm? interface
 
# FIN
