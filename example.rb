# frozen_string_literal: true

require_relative "lib/translation_api"

if ARGV.empty?
  puts "引数が必要です: ruby example.rb \"text\""
  exit
end

text = ARGV.join(" ")
TranslationAPI.configure do |config|
  config.language      = "english"
  config.provider      = :openai
  config.output_logs   = false
  config.except_words  = %w[hoge fuga]
  config.custom_prompt = "Please Samurai style."
end

begin
  translated_text = TranslationAPI.translate(text)
  p translated_text
rescue StandardError => e
  puts e
  puts e.backtrace
end
