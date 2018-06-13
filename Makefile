INFILES = $(shell find . -name "*.md")
OUTFILES = $(INFILES:.md=.html)

all: $(OUTFILES)

%.html: %.md footer.inc header.inc style.css
	m4 -PEIinc header.inc > $@
	bin/mark -i $< >> $@
	cat footer.inc >> $@
	sed -i 's|<body>|<body class="$(shell dirname $@)">|' $@

clean:
	rm -f $(OUTFILES)

preview: all
	python -m SimpleHTTPServer 8080

optimize:
	optipng img/*.png

PHONY: all clean
