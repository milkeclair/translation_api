# frozen_string_literal: true

require_relative "writer"

module TranslationAPI
  class Calculator
    class ArgumentError < StandardError; end
    MODEL_ERROR_MESSAGE =
      "Specified model is not supported. Please check the model name."

    # トークン数から利用料金を計算する
    #
    # @param [Integer] used_tokens 使用したトークン数
    # @param [String] token_type トークンの種類
    # @return [Float] 利用料金
    def self.calc_total_cost(used_tokens, token_type)
      model = ENV["OPENAI_MODEL"] || "gpt-5-mini"
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
        "gpt-5" => {
          input: 1.25 / one_million,
          output: 10.0 / one_million
        },
        "gpt-5-mini" => {
          input: 0.25 / one_million,
          output: 2.0 / one_million
        },
        "gpt-5-nano" => {
          input: 0.05 / one_million,
          output: 0.4 / one_million
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

      raise Calculator::ArgumentError, MODEL_ERROR_MESSAGE
    end
  end
end
