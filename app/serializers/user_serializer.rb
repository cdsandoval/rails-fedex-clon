class UserSerializer < ActiveModel::Serializer
  attributes  :id,
              :username,
              :email,
              :role,
              :address,
              :city,
              :country
end
