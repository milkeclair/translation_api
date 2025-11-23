# frozen_string_literal: true

class TranslationAPI
  module Provider
    class OpenAI
      class Model
        SUPPORTED_MODELS = [
          "gpt-5",
          "gpt-5-mini",
          "gpt-5-nano"
        ].freeze

        MODEL_ERROR_MESSAGE =
          "Specified model is not supported. Please check the model name."

        attr_reader :name

        def self.base
          SUPPORTED_MODELS[0]
        end

        def self.mini
          SUPPORTED_MODELS[1]
        end

        def self.nano
          SUPPORTED_MODELS[2]
        end

        def initialize(name)
          @name = name
          validate_model!
        end

        private

        def validate_model!
          raise MODEL_ERROR_MESSAGE unless SUPPORTED_MODELS.include?(@name)
        end
      end
    end
  end
end
