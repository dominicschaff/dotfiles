shell:
	poetry install
	poetry shell

setup:
# 	poetry export -o requirements.txt
	poetry build
# 	pip install --user --no-cache-dir --no-compile -r requirements.txt
	pip install --force-reinstall --user --no-cache-dir --no-compile dist/*.whl

clean:
	poetry run isort src
	poetry run black src