module LlmMetaClient
  class Engine < ::Rails::Engine
    isolate_namespace LlmMetaClient

    initializer "llm_meta_client.helpers" do
      ActiveSupport.on_load(:action_view) do
        include LlmMetaClient::Helpers
      end
    end
  end
end
