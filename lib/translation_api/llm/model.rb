# frozen_string_literal: true

class TranslationAPI
  module Llm
    class Model
      MODEL_ERROR_MESSAGE =
        "Specified model is not supported. Please check the model name."

      attr_reader :name

      def initialize(name)
        @name = name
        validate_model!
      end

      private

      def validate_model!
        supported_models =
          self.class.const_defined?(:SUPPORTED_MODELS) ? self.class::SUPPORTED_MODELS : []

        raise MODEL_ERROR_MESSAGE unless supported_models.include?(@name)
      end
    end
  end
end
