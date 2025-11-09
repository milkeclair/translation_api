# TranslationAPI

Translate using APIs.  
Requires api key.  

## For OpenAI

1. `touch .env`
2. Add `OPENAI_API_KEY=YOUR_API_KEY`  
3. Optional: `ENV["OPENAI_MODEL"]`
4. `TranslationAPI.translate("text")`

### Configuration Options

* output_logs (default: true)  
* language (default: "japanese")  
* provider (default: :openai)  
* except_words (default: [])  

### Output

* Translated_text
* Used Tokens
* Cost Spent(https://openai.com/api/pricing/)

## Example

Exec `ruby example.rb "text"`

```ruby
TranslationAPI.configure do |config|
  config.language     = "english"
  config.provider     = :deepl
  config.output_logs  = false
  config.except_words = %w[hoge fuga]
end

TranslationAPI.translate("text")
```
