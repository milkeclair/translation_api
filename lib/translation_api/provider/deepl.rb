# frozen_string_literal: true

require "dotenv"
require "deepl"

class TranslationAPI
  module Provider
    class DeepL
      SYSTEM_PROMPT_BASE = <<~TEXT
        Keep symbols
      TEXT

      API_KEY_ERROR_MESSAGE = "API key is not found."

      LANGUAGE_UNSUPPORTED_MESSAGE = "This language is unsupported by DeepL."

      def initialize(pro:, except_words: [], language: "japanese")
        @pro = pro
        @language = language

        setup_deepl_config!
        validate_supported_language!

        @system_content = SYSTEM_PROMPT_BASE + except_option_text(except_words)
        @language = supported_languages[language.to_sym]
      end

      def translate(text)
        return text if text.strip.empty?

        ::DeepL.translate(text, nil, @language, context: @system_content).text
      end

      private

      def setup_deepl_config!
        validate_api_key!

        ::DeepL.configure do |config|
          config.auth_key = ENV["DEEPL_API_KEY"] || ENV["DEEPL_AUTH_KEY"]
          config.host = @pro ? "https://api.deepl.com" : "https://api-free.deepl.com"
        end
      end

      def validate_api_key!
        raise API_KEY_ERROR_MESSAGE unless ENV["DEEPL_API_KEY"] || ENV["DEEPL_AUTH_KEY"]
      end

      def validate_supported_language!
        raise LANGUAGE_UNSUPPORTED_MESSAGE unless supported_language?
      end

      def supported_languages
        @supported_languages ||=
          ::DeepL.languages.to_h { [it.name.downcase.to_sym, it.code] }
      end

      def supported_language?
        supported_languages.key?(@language.to_sym)
      end

      def except_option_text(except_words)
        return "" if except_words.empty?

        <<~TEXT
          Words listed next are not translated: [#{except_words.join(", ")}]
        TEXT
      end
    end
  end
end
