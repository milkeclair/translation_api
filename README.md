## 概要

ChatGPTを使って文字列を日本語に翻訳する  
OpenAIのAPIキーが必要  
`.env`を作成し、`OPENAI_API_KEY=YOUR_API_KEY`を追加する  
`ENV["OPENAI_MODEL"]`がない場合は、[gpt-4o-mini](https://openai.com/index/gpt-4o-mini-advancing-cost-efficient-intelligence/)をデフォルトで使用する  

* 翻訳されたテキスト
* 使用したトークン数
* 掛かった金額([参考](https://openai.com/api/pricing/))

が出力される  

## 使用例

詳しくは、example.rbを参照  
`ruby example.rb "text"`で実行できる
