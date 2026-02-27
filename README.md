# llm_meta_client

A Rails Engine for integrating multiple LLM providers into your application. Provides scaffold and authentication generators to quickly build LLM-powered chat applications with support for OpenAI, Anthropic, Google, and Ollama.

## Features

- **Scaffold generator** — Generates models, controllers, views, and JavaScript controllers for a full chat UI with Turbo Stream support
- **Authentication generator** — Sets up Devise with Google OAuth2 for user authentication
- **Core modules** — `ServerQuery`, `ServerResource`, `Helpers`, `ChatManageable`, `HistoryManageable`, and custom exception classes

## Requirements

- Ruby >= 3.4
- Rails >= 8.1.1

## Installation

Add this line to your application's Gemfile:

```ruby
gem "llm_meta_client"
```

And then execute:

```bash
$ bundle install
```

## Usage

### Scaffold Generator

Generates a complete chat interface with LLM integration:

```bash
$ rails generate llm_meta_client:scaffold
```

This creates:

- **Models:** `Chat`, `Message`
- **Controllers:** `ChatsController`, `PromptsController`
- **Views:** Chat views (`new`, `edit`, Turbo Stream responses), message partials, shared form fields (`_family_field`, `_api_key_field`, `_model_field`), layout with header and sidebar
- **JavaScript:** Stimulus controllers (`llm_selector`, `chats_form`, `chat_title_edit`), popover
- **Initializer:** `config/initializers/llm_service.rb`
- **Migrations:** `create_chats`, `create_messages`
- **Routes:** Chats resource with `clear`, `start_new`, `download_all_csv`, `download_csv`, `update_title` actions

### Authentication Generator

Sets up user authentication with Devise and Google OAuth2:

```bash
$ rails generate llm_meta_client:authentication
```

This creates:

- **Model:** `User`
- **Controllers:** `Users::OmniauthCallbacksController`, `Users::SessionsController`
- **Initializers:** `config/initializers/devise.rb`, `config/initializers/omniauth.rb`
- **Locale:** `config/locales/devise.en.yml`
- **Migration:** `create_users`
- **Routes:** Devise routes with OmniAuth callbacks

## Configuration

The following environment variables are used:

| Variable | Description | Default |
|---|---|---|
| `LLM_SERVICE_BASE_URL` | Base URL for the external LLM service | `http://localhost:3000` |
| `SUMMARIZE_CONVERSATION_COUNT` | Number of messages to include in conversation context | `10` |
| `GOOGLE_CLIENT_ID` | Google OAuth2 client ID (authentication generator) | — |
| `GOOGLE_CLIENT_SECRET` | Google OAuth2 client secret (authentication generator) | — |

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
