require 'rails_helper'
require 'faker'

describe Api::SessionsController do
  before do
    User.delete_all
    @user = User.create(
      username: Faker::Name.unique.name,       
      email: Faker::Internet.email,          
      password: "123456",
      authentication_token: Devise.friendly_token[0, 30],
      city: Faker::Address.city,        
      country: Faker::Address.country,
      address: Faker::Address.street_address,  
      role: "regular"       
    )
  end

  describe 'Get login' do
    it 'return http status bad request when you do not pass parameters' do
      get :create
      expect(response).to have_http_status(:bad_request)
    end

    it 'render json with a specify error message when you do not pass parameters' do
      get :create
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("You have to pass the parameters 'email' and 'password'")
    end

    it 'return http status unauthorized when you pass email or password incorrect' do
      get :create, params: { email: "preuba@able.com", password: "123456" }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'render json with a specify error message when you do not pass parameters' do
      get :create, params: { email: "preuba@able.com", password: "123456" }
      expected_response = JSON.parse(response.body)
      expect(expected_response["errors"]["message"]).to eq("Incorrect email or password")
    end

    it 'return http status ok when you pass email and password right' do
      get :create, params: { email: @user.email, password: "123456" }
      expect(response).to have_http_status(:ok)
    end

    it 'render json with a token value ' do
      get :create, params: { email: @user.email, password: "123456" }
      expected_token = JSON.parse(response.body)
      expect(expected_token["token"]).to eq(@user.authentication_token)
    end
  end
end