require 'rails_helper'
require 'faker'

RSpec.describe Api::Admin::SalesController, type: :controller do

  before do
    User.delete_all
    Sender.delete_all
    Shipment.delete_all
    ShipmentLocation.delete_all
    con = 1
    5.times do
      Sender.create(
      store_name: Faker::Commerce.department,
      email: Faker::Internet.email,
      order_id: con,
      city: Faker::Address.city,        
      country: Faker::Address.country,
      )
      con += 1
    end
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
    25.times do
      Shipment.create(
        tracking_id: Faker::Alphanumeric.alphanumeric(20),
        origin_address: Faker::Address.full_address, 
        destination_address: Faker::Address.full_address, 
        weight: Faker::Number.between(1, 10),
        reception_date: Faker::Date.forward(60),
        estimated_delivery_date: Faker::Date.forward(60),
        freight_value: Faker::Number.between(500,10000),
        user_id: User.all.reduce([]){ |array, val| array << val.id }.sample,
        sender_id: Sender.all.reduce([]){ |array, val| array << val.id }.sample
      )
    end
    15.times do 
      ShipmentLocation.create(
        city: Faker::Address.city,
        country: Faker::Address.country,
        reception_date:Faker::Date.forward(20),
        shipment_id: Shipment.all.reduce([]){ |array, val| array << val.id }.sample,
      )
    end
  end

  describe 'GET report_top5_countries_recipients' do
    it 'returns http status unathorized
        when you do not pass the token in header' do
      get :report_top5_countries_recipients
      expect(response).to have_http_status(:unauthorized)
    end

    it 'render json with a specify error message
        when you do not pass the token in header' do
      get :report_top5_countries_recipients
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("Access denied")
    end

    it 'returns http status unathorized
        when you pass the token of a user with role regular' do
      request.headers['Authorization'] = "Token token=#{@user2.authentication_token}"
      get :report_top5_countries_recipients
      expect(response).to have_http_status(:unauthorized)
    end

    it 'render json with a specify error message
        when you pass the token of a user with role regular' do
      request.headers['Authorization'] = "Token token=#{@user2.authentication_token}"
      get :report_top5_countries_recipients
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("Access denied")
    end

    it 'returns http status ok' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      get :report_top5_countries_recipients
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET report_top5_countries_senders' do
    it 'returns http status unathorized
        when you do not pass the token in header' do
      get :report_top5_countries_senders
      expect(response).to have_http_status(:unauthorized)
    end

    it 'render json with a specify error message
        when you do not pass the token in header' do
      get :report_top5_countries_senders
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("Access denied")
    end

    it 'returns http status unathorized
        when you pass the token of a user with role regular' do
      request.headers['Authorization'] = "Token token=#{@user2.authentication_token}"
      get :report_top5_countries_senders
      expect(response).to have_http_status(:unauthorized)
    end

    it 'render json with a specify error message
        when you pass the token of a user with role regular' do
      request.headers['Authorization'] = "Token token=#{@user2.authentication_token}"
      get :report_top5_countries_senders
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("Access denied")
    end

    it 'returns http status ok' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      get :report_top5_countries_senders
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET report_top5_packages_sent' do
    it 'returns http status unathorized
        when you do not pass the token in header' do
      get :report_top5_packages_sent
      expect(response).to have_http_status(:unauthorized)
    end

    it 'render json with a specify error message
        when you do not pass the token in header' do
      get :report_top5_packages_sent
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("Access denied")
    end

    it 'returns http status unathorized
        when you pass the token of a user with role regular' do
      request.headers['Authorization'] = "Token token=#{@user2.authentication_token}"
      get :report_top5_packages_sent
      expect(response).to have_http_status(:unauthorized)
    end

    it 'render json with a specify error message
        when you pass the token of a user with role regular' do
      request.headers['Authorization'] = "Token token=#{@user2.authentication_token}"
      get :report_top5_packages_sent
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("Access denied")
    end

    it 'returns http status ok' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      get :report_top5_packages_sent
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET report_ranked_freight_value' do
    it 'returns http status unathorized
        when you do not pass the token in header' do
      get :report_ranked_freight_value
      expect(response).to have_http_status(:unauthorized)
    end

    it 'render json with a specify error message
        when you do not pass the token in header' do
      get :report_ranked_freight_value
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("Access denied")
    end

    it 'returns http status unathorized
        when you pass the token of a user with role regular' do
      request.headers['Authorization'] = "Token token=#{@user2.authentication_token}"
      get :report_ranked_freight_value
      expect(response).to have_http_status(:unauthorized)
    end

    it 'render json with a specify error message
        when you pass the token of a user with role regular' do
      request.headers['Authorization'] = "Token token=#{@user2.authentication_token}"
      get :report_ranked_freight_value
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("Access denied")
    end

    it 'returns http status ok' do
      request.headers['Authorization'] = "Token token=#{@user1.authentication_token}"
      get :report_ranked_freight_value
      expect(response).to have_http_status(:ok)
    end
  end

end