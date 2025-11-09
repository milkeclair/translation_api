# frozen_string_literal: true

require "singleton"

class TranslationAPI
  class Config
    include Singleton

    attr_accessor :language, :provider, :output_logs, :except_words

    def self.configure(&)
      instance.instance_exec(&)
    end

    def self.language = instance.language
    def self.provider = instance.provider
    def self.output_logs  = instance.output_logs
    def self.except_words = instance.except_words

    def initialize
      @language     = "japanese"
      @provider     = :openai
      @output_logs  = true
      @except_words = []
    end
  end
end
