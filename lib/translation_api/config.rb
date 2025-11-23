# frozen_string_literal: true

require "singleton"

class TranslationAPI
  class Config
    include Singleton

    attr_accessor :language, :provider, :output_logs, :except_words, :custom_prompt, :deepl_pro

    def self.configure(&block)
      block.call(instance)
    end

    def initialize
      @language      = "japanese"
      @provider      = :openai
      @output_logs   = true
      @except_words  = []
      @custom_prompt = nil
      @deepl_pro     = false
    end
  end
end
