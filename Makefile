IMAGE := registry.hf.space/sowndarya18-skincancerprediction:latest
PORT := 7860
PYTHON := .venv/bin/python

.PHONY: run run-docker pull setup

setup:
	python3.12 -m venv .venv
	$(PYTHON) -m pip install -U pip
	$(PYTHON) -m pip install -r requirements.txt

run: $(PYTHON)
	GRADIO_SERVER_NAME=0.0.0.0 GRADIO_SERVER_PORT=$(PORT) $(PYTHON) app.py

# Slow on Apple Silicon: amd64 image runs under QEMU emulation
run-docker:
	sudo docker run -it --rm -p $(PORT):7860 --platform=linux/amd64 \
		-e GRADIO_SERVER_NAME=0.0.0.0 \
		-e GRADIO_SERVER_PORT=7860 \
		-v "$(CURDIR)/app.py:/home/user/app/app.py:ro" \
		$(IMAGE) \
		python app.py

pull:
	sudo docker pull --platform=linux/amd64 $(IMAGE)

$(PYTHON):
	@$(MAKE) setup
