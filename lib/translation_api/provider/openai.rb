# frozen_string_literal: true

require_relative "openai/model"
require_relative "openai/prompt"
require_relative "openai/chat"
require_relative "openai/log"

class TranslationAPI
  module Provider
    class OpenAI
      def initialize(output_logs:, except_words:, language:, custom_prompt: nil)
        @model  = Model.new(ENV["OPENAI_MODEL"] || Model.nano)
        @prompt = Prompt.new(except_words:, language:, custom_prompt:)
        @chat   = Chat.new(model: @model, prompt: @prompt)
        @output_logs = output_logs
      end

      def translate(text)
        return text if text.strip.empty?

        @response = @chat.call(text)
        Log.new(model: @model, response: @response).write if @output_logs

        @response.translated_text
      end
    end
  end
end
