# frozen_string_literal: true

class TranslationAPI
  module Provider
    class OpenAI
      class Cost
        ONE_MILLION = 1_000_000
        BASE_MODEL_COST = 1.25 / ONE_MILLION

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
          base.merge(mini).merge(nano)
        end

        def base
          {
            @model.class.base => {
              input: BASE_MODEL_COST,
              output: BASE_MODEL_COST * normal_io_ratio[:output]
            }
          }
        end

        def mini
          {
            @model.class.mini => {
              input: BASE_MODEL_COST / normal_cost_diff_ratio,
              output: (BASE_MODEL_COST * normal_io_ratio[:output]) / normal_cost_diff_ratio
            }
          }
        end

        def nano
          mini_cost = mini.values[0][:input]

          {
            @model.class.nano => {
              input: mini_cost / normal_cost_diff_ratio,
              output: (mini_cost * normal_io_ratio[:output]) / normal_cost_diff_ratio
            }
          }
        end

        def normal_io_ratio
          {
            input: 1.0,
            output: 8.0
          }
        end

        def normal_cost_diff_ratio
          5.0
        end
      end
    end
  end
end
