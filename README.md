# TranslationAPI

Translate using APIs.  
Requires api key.  

## For OpenAI

1. `touch .env`
2. Add `OPENAI_API_KEY=YOUR_API_KEY` or `GEMINI_API_KEY=YOUR_API_KEY` or `DEEPL_API_KEY=YOUR_API_KEY` to `.env`
3. Optional: `ENV["OPENAI_MODEL"]` or `ENV["GEMINI_MODEL"]`
4. `TranslationAPI.translate("text")`

### Configuration Options

* language (default: "japanese")  
* provider (default: :openai)  
* output_logs (default: true)  
* except_words (default: [])  
* custom_prompt (default: nil)
  * Only for OpenAI and Gemini
* deepl_pro (default: false)
  * Only for DeepL

### Output(Only for OpenAI and Gemini)

* Translated_text
* Used Tokens
* Cost Spent
  * https://openai.com/api/pricing/
  * https://ai.google.dev/gemini-api/docs/pricing/

## Example

Exec `ruby example.rb "text"`

```ruby
TranslationAPI.configure do |config|
  config.language      = "english"
  config.provider      = :gemini
  config.output_logs   = false
  config.except_words  = %w[hoge fuga]
  config.custom_prompt = "Please Samurai style."
end

TranslationAPI.translate("text")
```
