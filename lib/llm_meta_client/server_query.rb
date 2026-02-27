module LlmMetaClient
  class ServerQuery
    def call(id_token, api_key_uuid, model_id, context, user_content)
      debug_log "Context: #{context}"
      context_and_user_content = "Context:#{context}, User Prompt: #{user_content}"
      debug_log "Request to LLM: \n===>\n#{context_and_user_content}\n===>"

      response = request(api_key_uuid, id_token, model_id, context_and_user_content)

      raise Exceptions::ServerError, "LLM server returned HTTP #{response.code}" unless response.success?

      response_body = response.parsed_response

      raise Exceptions::InvalidResponseError, "LLM server returned non-JSON response" unless response_body.is_a?(Hash)

      content = response_body.dig("response", "message") || ""

      raise Exceptions::EmptyResponseError, "LLM server returned empty response" if content.blank?

      debug_log "Response from LLM: \n<===\n#{content}\n<==>"

      content
    end

    private

    def debug_log(message)
      Rails.logger.info(message) if Rails.env.development?
    end

    def request(api_key_uuid, id_token, model_id, user_content)
      headers = { "Content-Type" => "application/json" }
      headers["Authorization"] = "Bearer #{id_token}" if id_token.present?

      HTTParty.post(
        url(api_key_uuid, model_id),
        headers: headers,
        body: { prompt: "#{user_content}" }.to_json,
        timeout: 300 # 5 minute timeout setting (both read and connect)
      )
    end

    def url(api_key_uuid, model_id)
      "#{Rails.application.config.llm_service_base_url}/api/llm_api_keys/#{api_key_uuid}/models/#{model_id}/chats"
    end
  end
end
