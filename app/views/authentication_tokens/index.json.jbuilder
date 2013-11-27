json.array!(@authentication_tokens) do |authentication_token|
  json.extract! authentication_token, :token, :valid_until, :user_id
  json.url authentication_token_url(authentication_token, format: :json)
end
