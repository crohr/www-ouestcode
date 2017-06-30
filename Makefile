INFILES = $(shell find . -name "*.md")
OUTFILES = $(INFILES:.md=.html)

all: $(OUTFILES)

%.html: %.md footer.inc header.inc style.css
	m4 -PEIinc header.inc > $@
	markdown $< >> $@
	cat footer.inc >> $@

clean:
	rm -f $(OUTFILES)

PHONY: all clean
