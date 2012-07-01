
all: notes.tex notes.html notes.json TexFilter.o

notes.html: notes.txt
	pandoc notes.txt -s -t json | ./tex_filter.hs | pandoc -f json --mathjax -s -o notes.html

notes.pdf: notes.tex
	pdflatex notes.tex
	pdflatex notes.tex

notes.tex: notes.txt
	pandoc -s -o notes.tex notes.txt

.PHONY: json
notes.json: notes.txt
	pandoc -s -o notes.json notes.txt

.PHONY: clean
clean:
	rm -rf *~ notes.html notes.tex notes.pdf

.PHONY: new
new: clean all

TexFilter.o: TexFilter.hs
	ghc -c TexFilter.hs

