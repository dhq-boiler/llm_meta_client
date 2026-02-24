require "prompt_manager"

module LlmMetaClient
  module HistoryManageable
    extend ActiveSupport::Concern

    included do
      include PromptManager::HistoryManageable
    end
  end
end
