# frozen_string_literal: true

require "dotenv"
require "deepl"

module TranslationAPI
  class DeepL
    def initialize
      Dotenv.load
      raise "API key is not found" unless ENV["DEEPL_API_KEY"]
    end
  end
end
