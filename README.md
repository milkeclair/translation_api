# TranslationAPI

Translate using APIs.  
Requires api key.  

## For OpenAI

1. `touch .env`
2. Add `OPENAI_API_KEY=YOUR_API_KEY`  
3. Optional: `ENV["OPENAI_MODEL"]`(default: gpt-4o-mini)
4. `TranslationAPI::Mediator.new.translate("text")`

### Init Options

* output_logs (default: true)  
* language (default: "japanese")  
* agent (default: :openai)  
* except_words (default: [])  

### Output

* Translated_text
* Used Tokens
* Cost Spent(https://openai.com/api/pricing/)

## Example

Exec `ruby example.rb "text"`
