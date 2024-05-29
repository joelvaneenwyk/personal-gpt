import logging

from injector import inject, singleton
from llama_index.core import set_global_tokenizer
from llama_index.core.llms import MockLLM, LLM
from transformers import AutoTokenizer

from personal_gpt.components.llm.prompt_helper import get_prompt_style
from personal_gpt.paths import models_cache_path, models_path
from personal_gpt.settings.settings import Settings

logger = logging.getLogger(__name__)


@singleton
class LLMComponent:
    llm: LLM

    @inject
    def __init__(self, settings: Settings) -> None:
        llm_mode = settings.llm.mode
        if settings.llm.tokenizer:
            set_global_tokenizer(
                AutoTokenizer.from_pretrained(
                    pretrained_model_name_or_path=settings.llm.tokenizer,
                    cache_dir=str(models_cache_path),
                )
            )

        logger.info("Initializing the LLM in mode=%s", llm_mode)
        match settings.llm.mode:
            case "local":
                from llama_index.core.llms import LlamaCPP

                prompt_style = get_prompt_style(settings.local.prompt_style)

                self.llm = LlamaCPP(
                    model_path=str(models_path / settings.local.llm_hf_model_file),
                    temperature=0.1,
                    max_new_tokens=settings.llm.max_new_tokens,
                    context_window=settings.llm.context_window,
                    generate_kwargs={},
                    # All to GPU
                    model_kwargs={"n_gpu_layers": -1, "offload_kqv": True},
                    # transform inputs into Llama2 format
                    messages_to_prompt=prompt_style.messages_to_prompt,
                    completion_to_prompt=prompt_style.completion_to_prompt,
                    verbose=True,
                )

            case "sagemaker":
                from personal_gpt.components.llm.custom.sagemaker import SagemakerLLM

                self.llm = SagemakerLLM(
                    endpoint_name=settings.sagemaker.llm_endpoint_name,
                    max_new_tokens=settings.llm.max_new_tokens,
                    context_window=settings.llm.context_window,
                )
            case "openai":
                from llama_index.llms.openai import OpenAI

                openai_settings = settings.openai
                self.llm = OpenAI(
                    api_base=openai_settings.api_base,
                    api_key=openai_settings.api_key,
                    model=openai_settings.model,
                )
            case "openailike":
                from llama_index.llms.openai_like import OpenAILike

                openai_settings = settings.openai
                self.llm = OpenAILike(
                    api_base=openai_settings.api_base,
                    api_key=openai_settings.api_key,
                    model=openai_settings.model,
                    is_chat_model=True,
                    max_tokens=None,
                    api_version="",
                )
            case "mock":
                self.llm = MockLLM()
            case "ollama":
                from llama_index.legacy.llms import Ollama

                ollama_settings = settings.ollama
                self.llm = Ollama(
                    model=ollama_settings.model, base_url=ollama_settings.api_base
                )
