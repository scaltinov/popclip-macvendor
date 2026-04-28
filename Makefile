NAME := MACVendor.popclipext
DIST := ../$(NAME)
ZIP := ../$(NAME)z

install:
	rsync -a --exclude='.git' --exclude='Makefile' --exclude='.gitignore' . "$(DIST)/"
	open "$(DIST)"

build:
	rsync -a --exclude='.git' --exclude='Makefile' --exclude='.gitignore' . "$(DIST)/"

release: build
	rm -f "$(ZIP)"
	cd .. && zip -r "$(NAME)z" "$(NAME)" -x "*.DS_Store"

clean:
	rm -rf "$(DIST)" "$(ZIP)"

.PHONY: install build release clean
