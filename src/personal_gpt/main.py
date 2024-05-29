"""FastAPI app creation, logger configuration and main API routes."""

import llama_index  # type: ignore, pylint: disable=unused-import
from llama_index.core.callbacks.global_handlers import set_global_handler

from personal_gpt.di import global_injector
from personal_gpt.launcher import create_app

# Add LlamaIndex simple observability
set_global_handler("simple")

app = create_app(global_injector)
