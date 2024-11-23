# frozen_string_literal: true

require "dotenv"
require "deepl"

module TranslationAPI
  class DeepL
    def initialize(output_logs: true, except_words: [], language: "japanese", pro: false)
      Dotenv.load
      setup_deepl_config!(pro: pro)
      @supported_languages = fetch_supported_languages
      validate_supported!(language)
      @system_content = except_option_text(except_words)
      @language = @supported_languages[language.to_sym]
    end

    def translate(text)
      return text if text.strip.empty?

      p ::DeepL.translate(text, nil, @language, context: @system_content).text
    end

    private

    def setup_deepl_config!(pro:)
      validate_api_key!

      ::DeepL.configure do |config|
        config.auth_key = ENV["DEEPL_API_KEY"] || ENV["DEEPL_AUTH_KEY"]
        config.host = pro ? "https://api.deepl.com" : "https://api-free.deepl.com"
      end
    end

    def validate_supported!(lang)
      raise "This language is unsupported by DeepL" unless supported?(lang)
    end

    def validate_api_key!
      raise "API key is not found" unless ENV["DEEPL_API_KEY"] || ENV["DEEPL_AUTH_KEY"]
    end

    def fetch_supported_languages
      ::DeepL.languages.to_h { |lang| [lang.name.downcase.to_sym, lang.code] }
    end

    def supported?(lang)
      @supported_languages.key?(lang.to_sym)
    end

    def except_option_text(except_words)
      return "" if except_words.empty?

      <<~TEXT
        Words listed next are not translated: [#{except_words.join(", ")}]
      TEXT
    end
  end
end
