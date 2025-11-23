# frozen_string_literal: true

require_relative "../../llm/model"

class TranslationAPI
  module Provider
    class OpenAI
      class Model < Llm::Model
        SUPPORTED_MODELS = [
          "gpt-5",
          "gpt-5-mini",
          "gpt-5-nano"
        ].freeze

        def self.base
          SUPPORTED_MODELS[0]
        end

        def self.mini
          SUPPORTED_MODELS[1]
        end

        def self.nano
          SUPPORTED_MODELS[2]
        end
      end
    end
  end
end
