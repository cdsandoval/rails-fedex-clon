require 'rails_helper'
require 'faker'

RSpec.describe Api::Deposit::ShipmentLocationsController, type: :controller do

  before do
    User.delete_all
    Sender.delete_all
    Shipment.delete_all

    Sender.create(
      store_name: Faker::Commerce.department,
      email: Faker::Internet.email,
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
      role: "deposit",
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
      user_id: @user2.id,
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
    @shipment_location1 = ShipmentLocation.create(
      city: Faker::Address.city,
      country: Faker::Address.country,
      reception_date: Faker::Date.forward(0),
      shipment_id: @shipment1.id
    )

  end

  describe 'GET history' do
    it 'returns http status unathorized
        when you do not pass the token in header' do
      get :history
      expect(response).to have_http_status(:unauthorized)
    end

    it 'render json with a specify error message
        when you do not pass the token in header' do
      get :history
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("Access denied")
    end

    it 'returns http status unathorized
        when you pass the token of a user with role regular' do
      request.headers['Authorization'] = "Token token=#{@user2.authentication_token}"
      get :history
      expect(response).to have_http_status(:unauthorized)
    end

    it 'render json with a specify error message
        when you pass the token of a user with role regular' do
      request.headers['Authorization'] = "Token token=#{@user2.authentication_token}"
      get :history
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("Access denied")
    end

    it 'returns http status bad request
        when you pass token but you do not pass parameter shipment_id' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      get :history
      expect(response).to have_http_status(:bad_request)
    end

    it 'render json with a specify error message
        when you pass token but you do not pass parameter shipment_id' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      get :history
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("You have to pass the argument 'shipment_id'")
    end

    it 'returns http status not found
        when you pass token and shipment_id but the last one does not exist' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      get :history, params: { shipment_id: "asdas78686" }
      expect(response).to have_http_status(:not_found)
    end

    it 'render json with a specify error message
        when you pass token and shipment_id but the last one does not exist' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      get :history, params: { shipment_id: "asdas78686" }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("It doesn't exist a shipment location with that shipment_id")
    end

    it 'returns http status ok' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      get :history, params: { shipment_id: @shipment1.id }
      expect(response).to have_http_status(:ok)
    end

    it 'render json with the number of elements correct' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      get :history, params: { shipment_id: @shipment1.id }
      expected_response = JSON.parse(response.body)
      expect(expected_response.size).to eq(1)
    end
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
        when you pass token but you do not pass parameter tracking_id' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create
      expect(response).to have_http_status(:bad_request)
    end

    it 'render json with a specify error message
        when you pass token but you do not pass parameter tracking_id' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("You have to pass the argument 'tracking_id'")
    end

    it 'returns http status ok' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { tracking_id: @shipment2.tracking_id }
      expect(response).to have_http_status(:created)
    end

    it 'render json
        with shipment_id attribute equal to shipment whose tracking_id is passed as parameter' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { tracking_id: @shipment2.tracking_id }
      expected_response = JSON.parse(response.body)
      expect(expected_response["shipment_id"]).to eq(@shipment2.id)
    end

    it 'returns http status forbidden
        when you send a post action twice in row' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { tracking_id: @shipment2.tracking_id }
      post :create, params: { tracking_id: @shipment2.tracking_id }
      expect(response).to have_http_status(:forbidden)
    end

    it 'returns http status forbidden
        when you send a post action twice in row' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { tracking_id: @shipment2.tracking_id }
      post :create, params: { tracking_id: @shipment2.tracking_id }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("The shipment is already stored in this location")
    end
  end

end