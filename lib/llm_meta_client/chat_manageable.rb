require "chat_manager"

module LlmMetaClient
  module ChatManageable
    extend ActiveSupport::Concern

    included do
      include ChatManager::ChatManageable
    end
  end
end
