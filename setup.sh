#!/usr/bin/env bash

set -eax

PYTHONPATH=. pip install -r requirements.txt
PYTHONPATH=. poetry run pip install -r requirements.txt
PYTHONPATH=. poetry run python scripts/setup
