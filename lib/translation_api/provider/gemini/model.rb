# frozen_string_literal: true

require_relative "../../llm/model"

class TranslationAPI
  module Provider
    class Gemini
      class Model < Llm::Model
        SUPPORTED_MODELS = [
          "gemini-3-pro-preview",
          "gemini-2.5-pro",
          "gemini-2.5-flash",
          "gemini-2.5-flash-lite"
        ].freeze

        def self.three_pro
          SUPPORTED_MODELS[0]
        end

        def self.two_five_pro
          SUPPORTED_MODELS[1]
        end

        def self.two_five_flash
          SUPPORTED_MODELS[2]
        end

        def self.two_five_flash_lite
          SUPPORTED_MODELS[3]
        end
      end
    end
  end
end
