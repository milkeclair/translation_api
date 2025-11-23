# frozen_string_literal: true

require_relative "../llm/prompt"
require_relative "../llm/log"
require_relative "gemini/model"
require_relative "gemini/chat"
require_relative "gemini/cost"

class TranslationAPI
  module Provider
    class Gemini
      def initialize(output_logs:, except_words:, language:, custom_prompt: nil)
        @model  = Model.new(ENV["GEMINI_MODEL"] || Model.two_five_flash)
        @prompt = Llm::Prompt.new(except_words:, language:, custom_prompt:)
        @chat   = Chat.new(model: @model, prompt: @prompt)
        @output_logs = output_logs
      end

      def translate(text)
        return text if text.strip.empty?

        @response = @chat.call(text)
        log.write if @output_logs

        @response.translated_text
      end

      def name
        "gemini"
      end

      private

      def log
        Llm::Log.new(provider: self, response: @response, cost: Cost.new(@model))
      end
    end
  end
end
