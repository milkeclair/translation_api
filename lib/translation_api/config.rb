# frozen_string_literal: true

require "singleton"

class TranslationAPI
  class Config
    include Singleton

    attr_accessor :language, :provider, :output_logs, :except_words

    def self.configure(&)
      instance.instance_exec(&)
    end

    def initialize
      @language     = "japanese"
      @provider     = :openai
      @output_logs  = true
      @except_words = []
    end
  end
end
