json.extract! food, :id, :name, :type, :weight, :created_at, :updated_at
json.url food_url(food, format: :json)
