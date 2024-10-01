# frozen_string_literal: true

require_relative "writer"

module JpTranslatorFromGpt
  class Calculator
    class ArgumentError < StandardError; end
    MODEL_ERROR_MESSAGE =
      "設定に無いモデルです。モデルをmodules/writerに追加するか、ENV[\"OPENAI_MODEL\"]を変更してください。"

    # トークン数から利用料金を計算する
    #
    # @param [Integer] used_tokens 使用したトークン数
    # @param [String] token_type トークンの種類
    # @return [Float] 利用料金
    def self.calc_total_cost(used_tokens, token_type)
      model = ENV["OPENAI_MODEL"] || "gpt-4o-mini"
      rate = get_token_rate(model, token_type)
      used_tokens * rate
    end

    # モデルとトークンの種類からトークンの単価を取得する
    # モデルが設定に無い場合はエラーを投げる
    #
    # @param [String] model モデル名
    # @param [String] token_type トークンの種類
    # @return [Float] トークンの単価
    def self.get_token_rate(model, token_type)
      token_rate = token_rate_hash
      validate_model(model, token_rate)
      token_rate[model][token_type.to_sym]
    end

    # トークン単価のハッシュを返す
    #
    # @return [Hash] トークン単価のハッシュ
    def self.token_rate_hash
      one_million = 1_000_000
      {
        "gpt-4o" => {
          input: 5.0 / one_million,
          output: 15.0 / one_million
        },
        "gpt-4o-2024-08-06" => {
          input: 2.5 / one_million,
          output: 10.0 / one_million
        },
        "gpt-4o-mini" => {
          input: 0.15 / one_million,
          output: 0.6 / one_million
        }
      }
    end

    # モデルが存在するかどうかを確認する
    #
    # @param [String] model モデル名
    # @param [Hash] token_rate トークンレートのハッシュ
    # @raise [Calculator::ArgumentError] モデルが存在しない場合
    def self.validate_model(model, token_rate)
      return if token_rate.key?(model)

      clear_files
      raise Calculator::ArgumentError, MODEL_ERROR_MESSAGE
    end

    # ファイルの内容を削除する
    #
    # @return [void]
    def self.clear_files
      File.write(Writer.text_path("translated_text.txt"), "")
      File.write(Writer.text_path("tokens.txt"), "")
      File.write(Writer.text_path("cost.txt"), "")
    end
  end
end
