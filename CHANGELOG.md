# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.5.0] - 2026-03-17

### Added

- Generation settings support:
  - `generation_settings` parameter in `ServerQuery` API layer for configuring LLM generation parameters
  - `generation_settings` threading through `Chat` model
  - `generation_settings` parameter extraction in `ChatsController`
  - Generation settings UI components for configuring parameters in chat forms

## [0.4.0] - 2026-03-11

### Added

- MCP (Model Context Protocol) tool selection support:
  - `ServerResource.fetch_mcp_servers` and `ServerResource.fetch_mcp_tools` for retrieving MCP server/tool data from the LLM service
  - `Api::McpServersController` with `index` and `tools` endpoints
  - API routes for MCP servers (`/api/mcp_servers` and `/api/mcp_servers/:uuid/tools`)
  - `tool_ids` parameter support through `ServerQuery`, `Chat` model, and `ChatsController`
  - Tool selector UI component (Stimulus controller + view partial) for selecting MCP tools in chat forms

### Changed

- Extracted `authenticated_get` helper in `ServerResource` to reduce duplication in authenticated API calls

### Security

- Escape HTML attribute values (`server.uuid`, `tool.id`) in tool selector to prevent XSS
- Use `CSS.escape()` for `querySelector` and `encodeURIComponent()` for fetch URLs to prevent selector/URL injection

## [0.3.0] - 2026-03-05

### Changed

- Update Ruby version requirement from 3.4.8 to 4.0.1
- Update gem dependencies to latest versions

## [0.2.0] - 2026-03-04

### Changed

- Switch configuration to use Rails credentials instead of environment variables

### Documentation

- Update README with architectural details, setup instructions, and Rails credentials usage

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
