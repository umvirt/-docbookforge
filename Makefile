SOURCE_STYLESHEETS_DIR = /usr/share/xml/docbook/stylesheet/docbook-xsl
STYLESHEETS_DIR = tmp/xsl/

FONTS_DIR = /usr/share/fonts/truetype/msttcorefonts

all: res foxsl html fonts pdf
res:
	cp -R src/res output
html:
	xsltproc -o output/html/ $(SOURCE_STYLESHEETS_DIR)/html/chunk.xsl src/docbook/document.xml
foxsl:
	rm -rf $(STYLESHEETS_DIR)
	mkdir -p $(STYLESHEETS_DIR)
	cp -r $(SOURCE_STYLESHEETS_DIR)/* $(STYLESHEETS_DIR)
	cp xsl/fo/param.xsl $(STYLESHEETS_DIR)/fo/
fo:
	xsltproc -o output/fo/document.fo $(STYLESHEETS_DIR)/fo/docbook.xsl src/docbook/document.xml 
pdf: fo
	mkdir output/pdf/
	fop -pdf output/pdf/document.pdf -c fop.cfg -fo output/fo/document.fo
pdfres: res pdf
fonts:
	mkdir -p tmp/fonts
	fop-ttfreader $(FONTS_DIR)/arial.ttf tmp/fonts/arial.xml
	fop-ttfreader $(FONTS_DIR)/ariali.ttf tmp/fonts/ariali.xml
	fop-ttfreader $(FONTS_DIR)/arialbd.ttf tmp/fonts/arialbd.xml
	fop-ttfreader $(FONTS_DIR)/arialbi.ttf tmp/fonts/arialbi.xml

	cp $(FONTS_DIR)/arial.ttf tmp/fonts/
	cp $(FONTS_DIR)/ariali.ttf tmp/fonts/
	cp $(FONTS_DIR)/arialbd.ttf tmp/fonts/
	cp $(FONTS_DIR)/arialbi.ttf tmp/fonts/

clear:
	rm -rf output/*
	rm -rf tmp/
