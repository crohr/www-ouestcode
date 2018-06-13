INFILES = $(shell find . -name "*.md")
OUTFILES = $(INFILES:.md=.html)

all: $(OUTFILES)

%.html: %.md footer.inc header.inc css/style.css
	m4 -PEIinc header.inc > $@
	bin/mark -i $< >> $@
	cat footer.inc >> $@
	sed -i ':begin;$!N;s/\(<code.*>\)\n/\1/;tbegin;P;D' $@
	sed -i 's|<body>|<body class="$(shell dirname $@)">|' $@

clean:
	rm -f $(OUTFILES)

preview: all
	docker build -t codelicacy .
	docker run -it -p 8080:80 -v $(shell pwd):/usr/share/nginx/html codelicacy

optimize:
	optipng img/*.png

PHONY: all clean
