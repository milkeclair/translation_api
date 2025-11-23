# frozen_string_literal: true

require "openai"
require_relative "openai/log"

class TranslationAPI
  module Provider
    class OpenAI
      SYSTEM_PROMPT_BASE = <<~TEXT
        Translate only.
        Return result only, no extra info
        Keep symbols
      TEXT

      API_KEY_ERROR_MESSAGE = "API key is not found."

      MODEL_ERROR_MESSAGE =
        "Specified model is not supported. Please check the model name."

      def initialize(output_logs:, except_words:, language:, custom_prompt: nil)
        validate_api_key!

        @client = init_client
        @output_logs   = output_logs
        @system_prompt = SYSTEM_PROMPT_BASE + except_option_text(except_words)
        @user_prompt   = user_prompt_text(language, custom_prompt)
      end

      def translate(text)
        return text if text.strip.empty?

        @response = chat_to_api(text)
        Log.new(self).write if @output_logs

        translated_text
      end

      def translated_text
        @response["choices"][0]["message"]["content"]
      end

      def using_model
        ENV["OPENAI_MODEL"] || "gpt-5-mini"
      end

      def dig_used_tokens(type:)
        case type
        when :input
          @response["usage"]["prompt_tokens"]
        when :output
          @response["usage"]["completion_tokens"]
        else
          raise ArgumentError, "Invalid token type: #{type}"
        end
      end

      private

      def validate_api_key!
        raise API_KEY_ERROR_MESSAGE unless ENV["OPENAI_API_KEY"]
      end

      def init_client
        ::OpenAI::Client.new(
          access_token: ENV["OPENAI_API_KEY"],
          log_errors: true
        )
      end

      def chat_to_api(text)
        @client.chat(
          parameters: {
            model: using_model,
            messages: [
              { role: "system", content: @system_prompt },
              { role: "user", content: @user_prompt + text }
            ]
          }
        )
      end

      def except_option_text(except_words)
        return "" if except_words.empty?

        <<~TEXT
          Words listed next are not translated: [#{except_words.join(", ")}]
        TEXT
      end

      def user_prompt_text(language, custom_prompt)
        <<~TEXT
          #{custom_prompt || ""}
          Please translate this text to #{language}:
        TEXT
      end
    end
  end
end
