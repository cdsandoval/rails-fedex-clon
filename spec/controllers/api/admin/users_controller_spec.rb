require 'rails_helper'
require 'faker'

RSpec.describe Api::Admin::UsersController, type: :controller do

  before do
    User.delete_all
    Sender.delete_all
    Shipment.delete_all

    Sender.create(
      store_name: Faker::Commerce.department,
      email: "diegotc86@gmail.com",
      order_id: 123
    )
    @user1 = User.create(
      username: Faker::Name.unique.name,
      email: Faker::Internet.email,
      password: "123456",
      authentication_token: Devise.friendly_token[0, 30],
      city: Faker::Address.city,
      country: Faker::Address.country,
      address: Faker::Address.street_address,
      role: "admin",
    )
    @user2 = User.create(
      username: Faker::Name.unique.name,
      email: Faker::Internet.email,
      password: "123456",
      authentication_token: Devise.friendly_token[0, 30],
      city: Faker::Address.city,
      country: Faker::Address.country,
      address: Faker::Address.street_address,
      role: "regular",
    )
    @shipment1 = Shipment.create(
      tracking_id: Faker::Alphanumeric.alphanumeric(10),
      origin_address: Faker::Address.full_address,
      destination_address: Faker::Address.full_address, 
      weight: Faker::Number.between(1, 10),
      reception_date: Faker::Date.forward(60),
      estimated_delivery_date: Faker::Date.forward(60),
      freight_value: Faker::Number.between(20 ,100),
      user_id: @user1.id,
      sender_id: Sender.all.first.id
    )
    @shipment2 = Shipment.create(
      tracking_id: Faker::Alphanumeric.alphanumeric(10),
      origin_address: Faker::Address.full_address,
      destination_address: Faker::Address.full_address, 
      weight: Faker::Number.between(1, 10),
      reception_date: Faker::Date.forward(60),
      estimated_delivery_date: Faker::Date.forward(60),
      freight_value: Faker::Number.between(20 ,100),
      user_id: @user2.id,
      sender_id: Sender.all.first.id
    )
  end

  describe 'POST create' do
    it 'returns http status unathorized
        when you do not pass the token in header' do
      post :create
      expect(response).to have_http_status(:unauthorized)
    end

    it 'render json with a specify error message
        when you do not pass the token in header' do
      post :create
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("Access denied")
    end

    it 'returns http status unathorized
        when you pass the token of a user with role regular' do
      request.headers['Authorization'] = "Token token=#{@user2.authentication_token}"
      post :create
      expect(response).to have_http_status(:unauthorized)
    end

    it 'render json with a specify error message
        when you pass the token of a user with role regular' do
      request.headers['Authorization'] = "Token token=#{@user2.authentication_token}"
      post :create
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("Access denied")
    end

    it 'returns http status bad request
        when you pass token but you do not pass none of parameters' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create
      expect(response).to have_http_status(:bad_request)
    end

    it 'render json with number of errors equal to all required parameters without value
        when you pass token but you do not pass none of parameters' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"].size).to eq(8)
    end

    it 'render json with number of errors equal to all required parameters without value
        when you pass token and parameter username' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :username => "Prueba1",
                              :format => :json }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"].size).to eq(7)
    end

    it 'render json with number of errors equal to all required parameters without value
        when you pass token and parameters
        username and email
        but the email\'s value is not correct' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :username => "Prueba1",
                              :email => "adasdasd",
                              :format => :json }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"].size).to eq(6)
    end

    it 'render json with number of errors equal to all required parameters without value
        when you pass token and parameters
        username and email' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :username => "Prueba1",
                              :email => "linzeur@gmail.com",
                              :format => :json }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"].size).to eq(5)
    end

    it 'render json with number of errors equal to all required parameters without value
        when you pass token and parameters
        username, email and city' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :username => "Prueba1",
                              :email => "linzeur@gmail.com",
                              :city => "Lima",
                              :format => :json }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"].size).to eq(4)
    end

    it 'render json with number of errors equal to all required parameters without value
        when you pass token and parameters
        username, email, city and country' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :username => "Prueba1",
                              :email => "linzeur@gmail.com",
                              :city => "Lima",
                              :country => "Peru",
                              :format => :json }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"].size).to eq(3)
    end

    it 'render json with number of errors equal to all required parameters without value
        when you pass token and parameters
        username, email, city, country and address' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :username => "Prueba1",
                              :email => "linzeur@gmail.com",
                              :city => "Lima",
                              :country => "Peru",
                              :address => "Los olivos",
                              :format => :json }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"].size).to eq(2)
    end
    
    it 'render json with number of errors equal to all required parameters without value
        when you pass token and parameters
        username, email, city, country, address and role
        but the role\'s value is not between admin, sales, deposit and regular' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :username => "Prueba1",
                              :email => "linzeur@gmail.com",
                              :city => "Lima",
                              :country => "Peru",
                              :address => "Los olivos",
                              :role => "asdasd",
                              :format => :json }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"].size).to eq(2)
    end

    it 'render json with number of errors equal to all required parameters without value
        when you pass token and parameters
        username, email, city, country and role
        and the role\'s value is between admin, sales, deposit and regular' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :username => "Prueba1",
                              :email => "linzeur@gmail.com",
                              :city => "Lima",
                              :country => "Peru",
                              :address => "Los olivos",
                              :role => "sales",
                              :format => :json }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"].size).to eq(1)
    end

    it 'returns http status created
        when you pass token and all parameters and all have correct values' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :username => "Prueba1",
                              :email => "linzeur@gmail.com",
                              :city => "Lima",
                              :country => "Peru",
                              :address => "Los olivos",
                              :role => "sales",
                              :password => "123456",
                              :format => :json }
      expect(response).to have_http_status(:created)
    end

    it 'render json will all attributes\' value equals to parameters sended
  when you pass token and  all parameters and all have correct values' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :username => "Prueba1",
                              :email => "linzeur@gmail.com",
                              :city => "Lima",
                              :country => "Peru",
                              :address => "Los olivos",
                              :role => "sales",
                              :password => "123456",
                              :format => :json }
      expected_response = JSON.parse(response.body)
      expect(expected_response["username"]).to eq("Prueba1")
      expect(expected_response["email"]).to eq("linzeur@gmail.com")
      expect(expected_response["city"]).to eq("Lima")
      expect(expected_response["country"]).to eq("Peru")
      expect(expected_response["role"]).to eq("sales")
    end
  end

end