require 'rails_helper'

RSpec.describe "Followers", type: :request do

  let!(:user) { create(:user) }

  describe "GET /accounts/:account_id/followers" do
    it "200 Status" do
      get account_followers_path(account_id: user.id)
      expect(response).to have_http_status(200)
    end
  end
end
