json.extract! like, :id, :user_id, :likable_id, :likable_type, :created_at, :updated_at
json.url like_url(like, format: :json)
