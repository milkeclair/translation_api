# frozen_string_literal: true

require "dotenv"
require_relative "translation_api/version"
require_relative "translation_api/config"
require_relative "translation_api/provider/openai"
require_relative "translation_api/provider/deepl"
require "debug"

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

  def initialize(**options)
    use_provided_options(options)
    use_default_options

    @provider = init_provider(@provider)
  end

  def config
    self.class.config
  end

  def translate(text)
    @provider.translate(text)
  end

  private

  def use_provided_options(options)
    options.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def use_default_options
    self.class.config.instance_variables.each do |var|
      key = var.to_s.delete_prefix("@").to_sym
      instance_variable_set("@#{key}", self.class.config.send(key))
    end
  end

  def init_provider(provider)
    case provider
    when :openai
      Provider::OpenAI.new(
        output_logs: @output_logs,
        except_words: @except_words,
        language: @language,
        custom_prompt: @custom_prompt
      )
    when :deepl
      Provider::DeepL.new(
        pro: config.deepl_pro,
        except_words: @except_words,
        language: @language,
        custom_prompt: @custom_prompt
      )
    else
      raise UNSUPPORTED_PROVIDER_MESSAGE
    end
  end
end
