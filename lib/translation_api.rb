# frozen_string_literal: true

require_relative "translation_api/version"
require_relative "translation_api/config"

class TranslationAPI
  def self.configure(&)
    Config.configure(&)
  end

  def self.translate(text, ...)
    new(...).translate(text)
  end

  def initialize(
    language:     Config.language,
    provider:     Config.provider,
    output_logs:  Config.output_logs,
    except_words: Config.except_words
  )
    @language = language
    @provider = provider_class(provider).new(output_logs:, except_words:, language:)
  end

  def translate(text)
    @provider.translate(text)
  end

  private

  def provider_class(provider)
    case provider
    when :openai
      Provider::OpenAI
    when :deepl
      Provider::DeepL
    else
      raise "Unsupported provider: #{provider}"
    end
  end

  def camelize(str)
    str.split("_").map(&:capitalize).join
  end
end
