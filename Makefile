proto_files	:=      $(shell find ./pb -iname "*.proto")

.PHONY: benchmark
benchmark: install
	./venv/bin/python benchmark.py

cc:
	mkdir -p cc
	protoc -I. --python_out=py --cpp_out=cc $(proto_files)

py:
	mkdir -p py
	protoc -I. --python_out=py --python_out=py $(proto_files)

venv:
	python3 -m virtualenv venv

install: venv cc py requirements.txt cy/addressbook.pyx
	./venv/bin/pip install -r requirements.txt
	cd cy && ../venv/bin/python setup.py install
