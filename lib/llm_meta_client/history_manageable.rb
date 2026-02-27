require "prompt_navigator"

module LlmMetaClient
  module HistoryManageable
    extend ActiveSupport::Concern

    included do
      include PromptNavigator::HistoryManageable
    end
  end
end
