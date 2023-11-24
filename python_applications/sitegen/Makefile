shell:
	poetry install
	poetry shell

build:
	-rm -rf dist
	poetry build

install: build
	pip install --user --no-cache-dir --no-compile dist/*.whl

clean:
	poetry run isort src
	poetry run black src
