require 'rails_helper'

RSpec.describe "Types", type: :request do
  describe "GET /types" do
    it "works! (now write some real specs)" do
      get types_path
      expect(response).to have_http_status(200)
    end
  end
end
