# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-02-27

### Added

- Rails Engine with core modules:
  - `ServerQuery` for making HTTP requests to LLM services
  - `ServerResource` for fetching available LLM options (OpenAI, Anthropic, Google, Ollama)
  - `Helpers` module integrating PromptNavigator and ChatManager helpers
  - `ChatManageable` and `HistoryManageable` concerns
  - Custom exceptions (`OllamaUnavailableError`, `ServerError`, `InvalidResponseError`, `EmptyResponseError`)
- Scaffold generator (`rails generate llm_meta_client:scaffold`):
  - Chat and Message models with migrations
  - ChatsController and PromptsController
  - Chat views with Turbo Stream support
  - Stimulus JavaScript controllers (llm_selector, chats_form, chat_title_edit)
  - LLM service initializer with configurable environment variables
  - Routes and importmap configuration
- Authentication generator (`rails generate llm_meta_client:authentication`):
  - User model with Devise and OmniAuth integration
  - Google OAuth2 sign-in support
  - OmniAuth callbacks and sessions controllers
  - Devise initializer and locale files
