
class LlmMetaServerQuery
  def call(id_token, api_key_uuid, model_id, user_content)
    debug_log "Request to LLM: \n===>\n#{user_content}\n===>"
    response = request(api_key_uuid, id_token, model_id, user_content)
    response_body = response.parsed_response
    content = response_body.dig("response", "message") || ""

    debug_log "Response from LLM: \n<===\n#{content}\n<==>"

    content
  end

  private

  def debug_log(message)
    Rails.logger.info(message) if Rails.env.development?
  end

  def request(api_key_uuid, id_token, model_id, user_content)
    HTTParty.post(
      url(api_key_uuid, model_id),
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{id_token}"
      },
      body: { prompt: "#{user_content}" }.to_json,
      timeout: 300 # 5 minute timeout setting (both read and connect)
    )
  end

  def url(api_key_uuid, model_id)
    "#{Rails.application.config.llm_service_base_url}/api/llm_api_keys/#{api_key_uuid}/models/#{model_id}/chats"
  end
end
