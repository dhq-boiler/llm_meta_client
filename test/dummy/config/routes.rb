Rails.application.routes.draw do
  mount LlmMetaClient::Engine => "/llm_meta_client"
end
