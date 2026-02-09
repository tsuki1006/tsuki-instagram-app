require 'rails_helper'

RSpec.describe "Followings", type: :request do

  let!(:user) { create(:user) }

  describe "GET /accounts/:account_id/followings" do
    it "200 Status" do
      get account_followings_path(account_id: user.id)
      expect(response).to have_http_status(200)
    end
  end
end
