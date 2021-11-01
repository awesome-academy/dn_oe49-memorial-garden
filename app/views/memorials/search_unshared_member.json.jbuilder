json.names do
  json.array!(@users_by_name) do |user|
    json.name user.name + ', Email:' + user.email
    json.email user.email
  end
end

json.emails do
  json.array!(@users_by_email) do |user|
    json.name user.email
    json.email user.email
  end
end
