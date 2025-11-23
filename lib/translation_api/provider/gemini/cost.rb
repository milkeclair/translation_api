# frozen_string_literal: true

class TranslationAPI
  module Provider
    class Gemini
      class Cost
        ONE_MILLION = 1_000_000

        def initialize(model)
          @model = model
        end

        def input_cost(used_tokens)
          calculate_cost(used_tokens, :input)
        end

        def output_cost(used_tokens)
          calculate_cost(used_tokens, :output)
        end

        private

        def calculate_cost(used_tokens, type)
          used_tokens * token_rates[@model.name][type]
        end

        def token_rates
          three_pro.merge(two_five_pro).merge(two_five_flash).merge(two_five_flash_lite)
        end

        def three_pro
          {
            @model.class.three_pro => {
              input: 2.0 / ONE_MILLION,
              output: (2.0 * pro_cost_diff_ratio) / ONE_MILLION
            }
          }
        end

        def two_five_pro
          {
            @model.class.two_five_pro => {
              input: 1.25 / ONE_MILLION,
              output: (1.25 * pro_cost_diff_ratio) / ONE_MILLION
            }
          }
        end

        def two_five_flash
          {
            @model.class.two_five_flash => {
              input: 0.3 / ONE_MILLION,
              output: 2.5 / ONE_MILLION
            }
          }
        end

        def two_five_flash_lite
          {
            @model.class.two_five_flash_lite => {
              input: 0.1 / ONE_MILLION,
              output: 0.4 / ONE_MILLION
            }
          }
        end

        def pro_cost_diff_ratio
          2.0
        end
      end
    end
  end
end
