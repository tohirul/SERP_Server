.PHONY: install run dev freeze clean help check test format

VENV_DIR := .venv
PYTHON_BIN := $(shell command -v python3.10 || command -v python3)
PYTHON := $(VENV_DIR)/bin/python
PIP := $(VENV_DIR)/bin/pip
UVICORN := $(VENV_DIR)/bin/uvicorn
REQUIREMENTS ?= requirements.txt
APP_MODULE := app.server:app

install:
	@if [ ! -d "$(VENV_DIR)" ]; then \
		if [ -z "$(PYTHON_BIN)" ]; then \
			echo "❌ Python 3.10 or 3 not found."; \
			exit 1; \
		fi; \
		echo "🔧 Creating virtual environment using $(PYTHON_BIN)..."; \
		$(PYTHON_BIN) -m venv $(VENV_DIR); \
	fi
	@if [ ! -f "$(REQUIREMENTS)" ]; then \
		echo "⚠️  No $(REQUIREMENTS) file found. Creating empty one..."; \
		touch $(REQUIREMENTS); \
	fi
	@echo "✅ Installing dependencies from $(REQUIREMENTS)..."
	@$(PIP) install --upgrade pip > /dev/null
	@$(PIP) install -r $(REQUIREMENTS)

run:
	@if [ ! -x "$(UVICORN)" ]; then \
		echo "❌ Uvicorn not found in virtual environment. Run 'make install' first."; \
		exit 1; \
	fi
	@echo "🚀 Running FastAPI server..."
	@$(UVICORN) $(APP_MODULE) --reload

dev:
	@echo "🚀 Launching development server with virtual environment..."
	make install
	make run

freeze:
	@echo "📄 Freezing dependencies into $(REQUIREMENTS)..."
	@$(PIP) freeze > $(REQUIREMENTS)

clean:
	@echo "🧹 Cleaning project files..."
	@rm -rf $(VENV_DIR) __pycache__ .mypy_cache .pytest_cache
	@find . -type d -name '__pycache__' -exec rm -rf {} +
	@find . -name '*.pyc' -delete
	@find . -name '*.DS_Store' -delete

check:
	@echo "🐍 Python binary: $(PYTHON_BIN)"
	@$(PYTHON_BIN) --version

test:
	@$(PYTHON) -m pytest

format:
	@$(PYTHON) -m black .

help:
	@echo "📌 Usage:"
	@echo "  make install   - Create virtual environment and install dependencies"
	@echo "  make run       - Run FastAPI app with Uvicorn"
	@echo "  make dev       - Install dependencies and run the app"
	@echo "  make freeze    - Freeze dependencies into requirements.txt"
	@echo "  make clean     - Delete venv and Python cache files"
	@echo "  make check     - Print Python binary and version"
	@echo "  make test      - Run tests using pytest"
	@echo "  make format    - Format code using Black"
