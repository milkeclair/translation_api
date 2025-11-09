# frozen_string_literal: true

require "dotenv"
require_relative "translation_api/version"
require_relative "translation_api/config"
require_relative "translation_api/provider/openai"
require_relative "translation_api/provider/deepl"

class TranslationAPI
  UNSUPPORTED_PROVIDER_MESSAGE = "This provider is unsupported."

  Dotenv.load

  def self.config
    Config.instance
  end

  def self.configure(&)
    Config.configure(&)
  end

  def self.translate(text, **)
    new(**).translate(text)
  end

  def initialize(
    language:     config.language,
    provider:     config.provider,
    output_logs:  config.output_logs,
    except_words: config.except_words
  )
    @language     = language
    @output_logs  = output_logs
    @except_words = except_words
    @provider     = init_provider(provider)
  end

  def config
    self.class.config
  end

  def translate(text)
    @provider.translate(text)
  end

  private

  def init_provider(provider)
    case provider
    when :openai
      Provider::OpenAI.new(
        output_logs: @output_logs,
        except_words: @except_words,
        language: @language
      )
    when :deepl
      Provider::DeepL.new(
        pro: config.deepl_pro,
        except_words: @except_words,
        language: @language
      )
    else
      raise UNSUPPORTED_PROVIDER_MESSAGE
    end
  end
end
