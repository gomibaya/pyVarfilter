.PHONY: help prepare-dev test lint securitylint banditenv securitylint clean clean-build clean-pyc clean-bandit clean-output build publishpip publishpiptest

VENV_NAME?=venv
VENV_ACTIVATE=. $(VENV_NAME)/bin/activate
PYTHON=${VENV_NAME}/bin/python3
BANDIT=bandit-env/bin/bandit

ODIR=output
SDIR=varfilter
TDIR=tests

_SRCS = filter.py types.py varfilter.py
SRCS = $(patsubst %,$(SDIR)/%,$(_SRCS))
LINTS = $(patsubst %,$(ODIR)/%.lint,$(_SRCS))
SECURES = $(patsubst %,$(ODIR)/%.secure,$(_SRCS))
TESTS = $(patsubst %,$(ODIR)/test_unit_%.test,$(_SRCS))

.DEFAULT: help
help:
	@echo "make prepare-dev"
	@echo "       prepare development environment, use only once"
	@echo "make test"
	@echo "       run tests"
	@echo "make lint"
	@echo "       run pylama"
	@echo "make full"
	@echo "		  check all the python files in projects"
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
	${PYTHON} ${TDIR}/test_unit_filter.py
	${PYTHON} ${TDIR}/test_unit_varfilter.py

lint: venv
	pylama varfilter/*.py
    #${PYTHON} -m pylint
    #${PYTHON} -m mypy
    
$(ODIR)/%.py.lint: $(SDIR)/%.py
	@echo "lint $<"
	@pylama --report $@  $< && echo "success!" || { cat $@; rm $@; exit 1; }

$(ODIR)/%.py.secure: $(SDIR)/%.py
	@echo "bandit $<"
	@${BANDIT} -o $@  $< && echo "success!" || { cat $@; rm $@; exit 1; }

$(ODIR)/%.py.test: $(TDIR)/%.py
	@echo "test $<"
	@${PYTHON} $< > $@ 2>&1 && echo "success!" || { cat $@; rm $@; exit 1; }
		
full: $(LINTS) $(SECURES) $(TESTS)
    
banditenv:
	virtualenv bandit-env
	bandit-env/bin/pip3 -q install bandit
    
securitylint: banditenv
	${BANDIT} -r varfilter/

#run: venv
#    ${PYTHON} app.py

#doc: venv
#    $(VENV_ACTIVATE) && cd docs; make html

clean: clean-build clean-pyc clean-output

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

clean-bandit:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	
clean-output:
	find $(ODIR) -name '*.py.lint' -exec rm -f {} +
	find $(ODIR) -name '*.py.secure' -exec rm -f {} +
	find $(ODIR) -name '*.py.test' -exec rm -f {} +

build: lint test securitylint
	${PYTHON} setup.py sdist bdist_wheel
	
publishpip: build
	${PYTHON} -m twine upload dist/*
	
publishpiptest: build
	${PYTHON} -m twine upload --repository-url https://test.pypi.org/legacy/ dist/*
	