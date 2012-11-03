# Start Makefile for OCR

EXEC=ocr # Executable's name
EXEC2=part_chars #EOL
EXEC3=part_rot90 #EOL
OCAML=ocamlopt # Compilator's name
OCAMLC=ocamlc
OCAMLFLAGS=-I +sdl -cclib -lunix # Flags
OCAMLLD=bigarray.cmxa sdl.cmxa sdlloader.cmxa unix.cmxa # libraries
OCAMLSRC2=tools.ml compare.ml line.ml chars_return2.ml #EOL
OCAMLSRC=rot.ml # tools.ml compare.ml line.ml chars_return.ml rot.ml #EOL
OCAMLSRC3=tools.ml compare.ml line.ml chars_return.ml rot2.ml #EOL
OCAMLMLI=  #EOL

# OCAMLCMO=${OCAMLSRC:.ml=.cmo}
OCAMLCMX=${OCAMLSRC:.ml=.cmx}
OCAMLCMX2=${OCAMLSRC2:.ml=.cmx}
OCAMLCMX3=${OCAMLSRC3:.ml=.cmx}
OCAMLCMI=${OCAMLMLI:.mli=.cmi}

all: ${EXEC} ${EXEC2} ${EXEC3}

${EXEC}: ${OCAMLCMX}
	${OCAML} ${OCAMLFLAGS} ${OCAMLLD} -o ${EXEC} ${OCAMLCMX}

${EXEC2}: ${OCAMLCMX2}
	${OCAML} ${OCAMLFLAGS} ${OCAMLLD} -o ${EXEC2} ${OCAMLCMX2}

${EXEC3}: ${OCAMLCMX3}
	${OCAML} ${OCAMLFLAGS} ${OCAMLLD} -o ${EXEC3} ${OCAMLCMX3}

.SUFFIXES: .ml .mli .cmi .cmx .cmo

.ml.cmx:
	${OCAML} ${OCAMLFLAGS} -c $<

.mli.cmi:
	 ${OCAMLC} ${OCAMLFLAGS} -c $<

clean:
	rm -f *.o *.cm? *~

fullclean::clean
	rm -f ${EXEC} ${EXEC2} ${EXEC3}

#EOF
