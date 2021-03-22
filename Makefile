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
	docker build -t ouestcode .
	docker run -it -p 5678:80 -v $(shell pwd):/usr/share/nginx/html ouestcode

optimize:
	optipng img/**/*.png

PHONY: all clean

build:
	docker-compose build

deploy: build
	docker stack deploy -c docker-compose.yml ouestcode-web
