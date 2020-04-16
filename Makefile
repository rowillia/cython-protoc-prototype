proto_files	:=      $(shell find ./pb -iname "*.proto")

.PHONY: proto
proto:
	mkdir -p cc
	mkdir -p py
	protoc -I. --python_out=py --cpp_out=cc $(proto_files)

venv:
	python3 -m virtualenv venv

.PHONY: install
install: venv proto
	./venv/bin/pip install -r requirements.txt
	cd cy && ../venv/bin/python setup.py install

.PHONY: benchmark
benchmark: install
	./venv/bin/python benchmark.py