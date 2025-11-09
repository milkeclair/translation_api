# frozen_string_literal: true

require_relative "lib/translation_api"

if ARGV.empty?
  puts "引数が必要です: ruby example.rb \"text\""
  exit
end

text = ARGV.join(" ")
TranslationAPI.configure do |config|
  config.language     = "english"
  config.provider     = :deepl
  config.except_words = %w[hoge fuga]
end

translated_text = TranslationAPI.translate(text)
p translated_text
