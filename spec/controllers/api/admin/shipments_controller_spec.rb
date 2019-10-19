require 'rails_helper'
require 'faker'

RSpec.describe Api::Admin::ShipmentsController, type: :controller do

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

  describe 'GET search' do
    it 'returns http status unathorized
        when you do not pass the token in header' do
      get :search
      expect(response).to have_http_status(:unauthorized)
    end

    it 'render json with a specify error message
        when you do not pass the token in header' do
      get :search
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("Access denied")
    end

    it 'returns http status unathorized
        when you pass the token of a user with role regular' do
      request.headers['Authorization'] = "Token token=#{@user2.authentication_token}"
      get :search
      expect(response).to have_http_status(:unauthorized)
    end

    it 'render json with a specify error message
        when you pass the token of a user with role regular' do
      request.headers['Authorization'] = "Token token=#{@user2.authentication_token}"
      get :search
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("Access denied")
    end

    it 'returns http status bad request
        when you pass token but you do not pass parameter tracking_id' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      get :search
      expect(response).to have_http_status(:bad_request)
    end

    it 'render json with a specify error message
        when you pass token but you do not pass parameter tracking_id' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      get :search
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("You have to pass the argument 'tracking_id'")
    end

    it 'returns http status not found
        when you pass token and tracking_id but the last one does not exist' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      get :search, params: { tracking_id: "asdas78686" }
      expect(response).to have_http_status(:not_found)
    end

    it 'render json with a specify error message
        when you pass token and tracking_id but the last one does not exist' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      get :search, params: { tracking_id: "asdas78686" }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("It doesn't exist a shipment with that tracking id")
    end

    it 'returns http status ok' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      get :search, params: { tracking_id: @shipment1.tracking_id }
      expect(response).to have_http_status(:ok)
    end

    it 'render json with general attributes
        when you pass a tracking_id but it does not belong you' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      get :search, params: { tracking_id: @shipment2.tracking_id }
      expected_response = JSON.parse(response.body)
      expect(expected_response.keys).not_to include("recipient")
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
        when you pass token and parameter origin_address' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :origin_address => "Lurin 345", :format => :json }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"].size).to eq(7)
    end

    it 'render json with number of errors equal to all required parameters without value
        when you pass token and parameters
        origin_address and destination_address' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :origin_address => "Lurin 345",
                              :destination_address => "Los Olivos Huandoy",
                              :format => :json }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"].size).to eq(6)
    end

    it 'render json with number of errors equal to all required parameters without value
        when you pass token and parameters
        origin_address, destination_address and weight
        but the weight\'s value is not a number' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :origin_address => "Lurin 345",
                              :destination_address => "Los Olivos Huandoy",
                              :weight => "prueba",
                              :format => :json }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"].size).to eq(6)
    end

    it 'render json with number of errors equal to all required parameters without value
        when you pass token and parameters
        origin_address, destination_address and weight,
        and the weight\'s value is a number' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :origin_address => "Lurin 345",
                              :destination_address => "Los Olivos Huandoy",
                              :weight => 34,
                              :format => :json }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"].size).to eq(5)
    end

    it 'render json with number of errors equal to all required parameters without value
        when you pass token and parameters
        origin_address, destination_address, weight and estimated_delivery_date
        but the estimated_delivery_date\'s value is not a date' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :origin_address => "Lurin 345",
                              :destination_address => "Los Olivos Huandoy",
                              :weight => 34,
                              :estimated_delivery_date => "asdasd",
                              :format => :json }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"].size).to eq(5)
    end

    it 'render json with number of errors equal to all required parameters without value
        when you pass token and parameters
        origin_address, destination_address, weight and estimated_delivery_date,
        and the estimated_delivery_date\'s value is a date' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :origin_address => "Lurin 345",
                              :destination_address => "Los Olivos Huandoy",
                              :weight => 34,
                              :estimated_delivery_date => "12/05/2019",
                              :format => :json }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"].size).to eq(4)
    end
    
    it 'render json with number of errors equal to all required parameters without value
        when you pass token and parameters
        origin_address, destination_address, weight, estimated_delivery_date and reception_date
        but the reception_date\'s value is not a date' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :origin_address => "Lurin 345",
                              :destination_address => "Los Olivos Huandoy",
                              :weight => 34,
                              :estimated_delivery_date => "12/05/2019",
                              :reception_date => "asdasd",
                              :format => :json }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"].size).to eq(4)
    end

    it 'render json with number of errors equal to all required parameters without value
        when you pass token and parameters
        origin_address, destination_address, weight, estimated_delivery_date and reception_date
        and the reception_date\'s value is a date' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :origin_address => "Lurin 345",
                              :destination_address => "Los Olivos Huandoy",
                              :weight => 34,
                              :estimated_delivery_date => "12/05/2019",
                              :reception_date => "12/05/2019",
                              :format => :json }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"].size).to eq(3)
    end

    it 'render json with number of errors equal to all required parameters without value
        when you pass token and parameters
        origin_address, destination_address, weight, estimated_delivery_date, reception_date, freight_value
        but the freight_value\'s value is not a number' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :origin_address => "Lurin 345",
                              :destination_address => "Los Olivos Huandoy",
                              :weight => 34,
                              :estimated_delivery_date => "12/05/2019",
                              :reception_date => "12/05/2019",
                              :freight_value => "sadasd",
                              :format => :json }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"].size).to eq(3)
    end

    it 'render json with number of errors equal to all required parameters without value
        when you pass token and parameters
        origin_address, destination_address, weight, estimated_delivery_date and reception_date, freight_value
        and the freight_value\'s value is a number' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :origin_address => "Lurin 345",
                              :destination_address => "Los Olivos Huandoy",
                              :weight => 34,
                              :estimated_delivery_date => "12/05/2019",
                              :reception_date => "12/05/2019",
                              :freight_value => 365,
                              :format => :json }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"].size).to eq(2)
    end

    it 'render json with number of errors equal to all required parameters without value
        when you pass token and  all parameters less sender_id
        but the user_id\'s value doesn\'t exist' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :origin_address => "Lurin 345",
                              :destination_address => "Los Olivos Huandoy",
                              :weight => 34,
                              :estimated_delivery_date => "12/05/2019",
                              :reception_date => "12/05/2019",
                              :freight_value => 365,
                              :user_id => "sadasd",
                              :format => :json }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"].size).to eq(2)
    end

    it 'render json with number of errors equal to all required parameters without value
        when you pass token and  all parameters less sender_id
        and the user_id\'s value exists' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :origin_address => "Lurin 345",
                              :destination_address => "Los Olivos Huandoy",
                              :weight => 34,
                              :estimated_delivery_date => "12/05/2019",
                              :reception_date => "12/05/2019",
                              :freight_value => 365,
                              :user_id => @user1.id,
                              :format => :json }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"].size).to eq(1)
    end

    it 'render json with number of errors equal to all required parameters without value
        when you pass token and  all parameters
        but the sender_id\'s value doesn\'t exist' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :origin_address => "Lurin 345",
                              :destination_address => "Los Olivos Huandoy",
                              :weight => 34,
                              :estimated_delivery_date => "12/05/2019",
                              :reception_date => "12/05/2019",
                              :freight_value => 365,
                              :user_id => @user1.id,
                              :sender_id => "sdasd",
                              :format => :json }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"].size).to eq(1)
    end

    it 'returns http status created
        when you pass token and  all parameters and all have correct values' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :origin_address => "Lurin 345",
                              :destination_address => "Los Olivos Huandoy",
                              :weight => 34,
                              :estimated_delivery_date => "12/05/2019",
                              :reception_date => "12/05/2019",
                              :freight_value => 365,
                              :user_id => @user1.id,
                              :sender_id => Sender.all.first.id,
                              :format => :json }
      expect(response).to have_http_status(:created)
    end

    it 'render json will all attributes\' value equals to parameters sended
        when you pass token and  all parameters and all have correct values' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      post :create, params: { :origin_address => "Lurin 345",
                              :destination_address => "Los Olivos Huandoy",
                              :weight => 34,
                              :estimated_delivery_date => "12/05/2019",
                              :reception_date => "12/05/2019",
                              :freight_value => 365,
                              :user_id => @user2.id,
                              :sender_id => Sender.all.first.id,
                              :format => :json }
      expected_response = JSON.parse(response.body)
      expect(expected_response["origin_address"]).to eq("Lurin 345")
      expect(expected_response["destination_address"]).to eq("Los Olivos Huandoy")
      expect(expected_response["weight"]).to eq(34)
      expect(expected_response["estimated_delivery_date"]).to eq("2019-05-12")
      expect(expected_response["reception_date"]).to eq("2019-05-12")
      expect(expected_response["freight_value"]).to eq(365)
      expect(expected_response["user_id"]).to eq(@user2.id)
      expect(expected_response["sender_id"]).to eq(Sender.all.first.id)
    end
  end

  describe 'PUT update' do
    it 'returns http status unathorized
        when you do not pass the token in header' do
      put :update, params: { id: "sadasdas"}
      expect(response).to have_http_status(:unauthorized)
    end

    it 'render json with a specify error message
        when you do not pass the token in header' do
      put :update, params: { id: "sadasdas"}
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("Access denied")
    end

    it 'returns http status unathorized
        when you pass the token of a user with role regular' do
      request.headers['Authorization'] = "Token token=#{@user2.authentication_token}"
      put :update, params: { id: "sadasdas"}
      expect(response).to have_http_status(:unauthorized)
    end

    it 'render json with a specify error message
        when you pass the token of a user with role regular' do
      request.headers['Authorization'] = "Token token=#{@user2.authentication_token}"
      put :update, params: { id: "sadasdas"}
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("Access denied")
    end

    it 'returns http status not found
        when you pass token and id but the last one does not exist' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      put :update, params: { id: "sadasdas"}
      expect(response).to have_http_status(:not_found)
    end

    it 'render json with a specify error message
        when you pass token and id but the last one does not exist' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      put :update, params: { id: "sadasdas"}
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("It doesn't exist a shipment with that id")
    end

    it 'returns http status bad request
        when you pass token but you do not pass parameter delivered_date' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      put :update, params: { id: @shipment1.id}
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns json with a specify error message
        when you pass token but you do not pass parameter delivered_date' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      put :update, params: { id: @shipment1.id}
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("You have to pass the argument 'delivered_date'")
    end

    it 'returns http status bad request
        when you pass token but you pass parameter delivered_date with a date less than reception_date\'s value' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      put :update, params: { id: @shipment1.id, delivered_date: "2013-01-01" }
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns json with a specify error message
        when you pass token but you do not pass parameter delivered_date' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      put :update, params: { id: @shipment1.id, delivered_date: "2013-01-01" }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("delivered_date must be greater or equal to reception_date")
    end

    # it 'returns http status ok' do
    #   request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
    #   put :update, params: { id: @shipment1.id, delivered_date: "25/08/2019"}
    #   expect(response).to have_http_status(:ok)
    # end

    # it 'render json with general attributes
    #     when you pass a tracking_id but it does not belong you' do
    #   request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
    #   put :update, params: { id: @shipment1.id, delivered_date: "25/08/2019"}
    #   expected_response = JSON.parse(response.body)
    #   expect(expected_response["delivered_date"]).to eq("2019-08-25")
    # end
  end

end