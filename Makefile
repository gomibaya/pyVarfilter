.PHONY: help prepare-dev test lint clean clean-build clean-pyc build publishpip publishpiptest

VENV_NAME?=venv
VENV_ACTIVATE=. $(VENV_NAME)/bin/activate
PYTHON=${VENV_NAME}/bin/python3

.DEFAULT: help
help:
	@echo "make prepare-dev"
	@echo "       prepare development environment, use only once"
	@echo "make test"
	@echo "       run tests"
	@echo "make lint"
	@echo "       run pylama"
#	@echo "make run"
#	@echo "       run project"
#	@echo "make doc"
#	@echo "       build sphinx documentation"
	@echo "make clean"
	@echo "		  clean project"
	@echo "make publishpip"
	@echo "		  publish in pypi.org"
	@echo "make publishpiptest"
	@echo "		  publish in test.pypi.org"
	
prepare-dev:
	sudo apt-get -y install python3 python3-pip
	python3 -m pip install virtualenv
	make venv

# Requirements are in setup.py, so whenever setup.py is changed, re-run installation of dependencies.
venv: $(VENV_NAME)/bin/activate
$(VENV_NAME)/bin/activate: setup.py
	test -d $(VENV_NAME) || virtualenv -p python3 $(VENV_NAME)
	${PYTHON} -m pip install -U pip
	${PYTHON} -m pip install -e .
	${PYTHON} -m pip install twine
	${PYTHON} -m pip install --upgrade setuptools wheel
	touch $(VENV_NAME)/bin/activate


test: venv
	${PYTHON} tests/test_varfilter_unittest.py

lint: venv
	pylama varfilter
    #${PYTHON} -m pylint
    #${PYTHON} -m mypy

#run: venv
#    ${PYTHON} app.py

#doc: venv
#    $(VENV_ACTIVATE) && cd docs; make html

clean: clean-build clean-pyc

clean-build:
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +

clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

build: lint test
	${PYTHON} setup.py sdist bdist_wheel
	
publishpip: build
	${PYTHON} -m twine upload dist/*
	
publishpiptest: build
	${PYTHON} -m twine upload --repository-url https://test.pypi.org/legacy/ dist/*
	