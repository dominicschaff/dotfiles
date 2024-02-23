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

test:
	poetry install --only-root
	cd tests; sitegen --config config_stories.toml
	cd tests/public; python -m http.server
