# frozen_string_literal: true

require_relative "cost"

class TranslationAPI
  module Provider
    class OpenAI
      class Log
        def initialize(provider)
          @provider = provider
          @cost = Cost.new(@provider)
        end

        def write
          write_translated_text
          write_used_tokens
          write_total_cost
        end

        private

        def write_translated_text
          log_file_path = text_path("translated_text.txt")

          File.open(log_file_path, "a") do |file|
            file.puts(@provider.translated_text)
          end
        end

        def write_used_tokens
          log_file_path = text_path("tokens.txt")

          existing_input_tokens, existing_output_tokens = read_existing_tokens
          tokens => { input_tokens:, output_tokens: }

          total_input_tokens  = existing_input_tokens + input_tokens
          total_output_tokens = existing_output_tokens + output_tokens

          File.open(log_file_path, "w") do |file|
            file.puts("input: #{total_input_tokens}")
            file.puts("output: #{total_output_tokens}")
          end
        end

        def read_existing_tokens
          log_file_path = text_path("tokens.txt")
          input_tokens, output_tokens = 0, 0

          if File.exist?(log_file_path)
            File.readlines(log_file_path).each do |line|
              tokens = line.split(":").last.strip.to_i
              input_tokens  = tokens if line.start_with?("input:")
              output_tokens = tokens if line.start_with?("output:")
            end
          end

          [input_tokens, output_tokens]
        end

        def write_total_cost
          log_file_path = text_path("cost.txt")
          tokens => { input_tokens:, output_tokens: }

          this_cost = @cost.input_cost(input_tokens) + @cost.output_cost(output_tokens)
          total_cost = this_cost + existing_cost

          File.open(log_file_path, "w") do |file|
            file.puts(format_cost(total_cost))
          end
        end

        def format_cost(cost)
          "$#{format("%.8f", cost)}"
        end

        def existing_cost
          log_file_path = text_path("cost.txt")

          File.exist?(log_file_path) ? File.read(log_file_path).gsub("$", "").to_f : 0.0
        end

        def tokens
          {
            input_tokens: @provider.dig_used_tokens(type: :input),
            output_tokens: @provider.dig_used_tokens(type: :output)
          }
        end

        def text_path(under_logs_path)
          output_dir = "translator_logs/openai"
          FileUtils.mkdir_p(output_dir) unless File.directory?(output_dir)

          File.join(output_dir, under_logs_path)
        end
      end
    end
  end
end
