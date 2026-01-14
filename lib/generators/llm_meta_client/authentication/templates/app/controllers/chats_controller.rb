class ChatsController < ApplicationController
  # Allow access without login
  skip_before_action :authenticate_user!, raise: false

  def new
    # Get or create current conversation
    @chat = current_chat
    @messages = @chat ? @chat.messages.order(:created_at) : []

    # Get LLM options available for guest users
    jwt_token = session[:jwt_token]
    @llm_options = LlmMetaServerResource.available_llm_options(jwt_token)
  rescue => e
    Rails.logger.error "Failed to load LLM options: #{e.message}"
    @llm_options = []
    flash.now[:alert] = "Failed to load LLM: #{e.message}"
  end

  def create
    @chat = current_chat
    llm_uuid = params[:api_key_uuid]
    model = params[:model]

    # Create a new conversation if it doesn't exist or LLM/model has changed
    if @chat.nil? || @chat.llm_uuid != llm_uuid || @chat.model != model
      @chat = Chat.create!(
        user: current_user,
        llm_uuid: llm_uuid,
        model: model
      )
      session[:chat_id] = @chat.id
    end

    if params[:message].present?
      # Save user message
      @chat.messages.create!(
        role: "user",
        content: params[:message]
      )

      # Send to LLM and get response
      begin
        messages_for_llm = @chat.messages.order(:created_at).map do |msg|
          { role: msg.role, content: msg.content }
        end

        response = send_to_llm(messages_for_llm, llm_uuid, model)

        # Save assistant response
        @chat.messages.create!(
          role: "assistant",
          content: response
        )
      rescue => e
        # Display error message as alert
        flash.now[:alert] = "An error occurred: #{e.message}"
        Rails.logger.error "Chat error: #{e.class} - #{e.message}\n#{e.backtrace.join("\n")}"
      end
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to new_chat_path }
    end
  end

  def clear
    if session[:chat_id].present?
      chat = Chat.find_by(id: session[:chat_id])
      chat&.destroy
    end
    session.delete(:chat_id)
    redirect_to new_chat_path, notice: "Chat history has been cleared"
  end

  private

  def current_chat
    return nil unless session[:chat_id].present?

    chat = Chat.find_by(id: session[:chat_id])

    # For guest users, only get conversations with nil user_id,
    # For logged-in users, only get their own conversations
    if current_user
      chat if chat&.user_id == current_user.id
    else
      chat if chat&.user_id.nil?
    end
  end

  def send_to_llm(messages, llm_uuid = nil, model = nil)
    # Get LLM options (Ollama only for guest users)
    jwt_token = session[:jwt_token]
    llm_options = LlmMetaServerResource.available_llm_options(jwt_token)

    # Error if no LLM is available
    raise "No LLM available" if llm_options.empty?

    # Use the first one if LLM UUID is not specified
    if llm_uuid.blank?
      llm_uuid = llm_options.first[:uuid]
    end

    # Validate the selected LLM
    selected_llm = llm_options.find { |opt| opt[:uuid] == llm_uuid }
    selected_llm ||= llm_options.first

    # Use the first available model if model is not specified
    if model.blank?
      model = selected_llm[:available_models]&.first || "default"
    end

    # Send chat request using LlmMetaServerQuery
    LlmMetaServerQuery.new.call(jwt_token, llm_uuid, model, messages)
  rescue StandardError => e
    Rails.logger.error "Error in send_to_llm: #{e.class} - #{e.message}"
    raise
  end
end
