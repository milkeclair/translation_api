# frozen_string_literal: true

require "dotenv"
require "deepl"

module TranslationAPI
  class DeepL
    def initialize
      Dotenv.load
      setup_deepl_config!
      @supported_languages = supported_languages
      source_lang = @supported_languages[:english]
      target_lang = @supported_languages[:japanese]
      p ::DeepL.translate("Hello, World!", source_lang, target_lang)
    end

    private

    def setup_deepl_config!
      raise "API key is not found" unless ENV["DEEPL_API_KEY"] || ENV["DEEPL_AUTH_KEY"]

      ::DeepL.configure do |config|
        config.auth_key = ENV["DEEPL_API_KEY"] || ENV["DEEPL_AUTH_KEY"]
        config.host = "https://api-free.deepl.com"
      end
    end

    def supported_languages
      ::DeepL.languages.to_h { |lang| [lang.name.downcase.to_sym, lang.code] }
    end
  end
end
