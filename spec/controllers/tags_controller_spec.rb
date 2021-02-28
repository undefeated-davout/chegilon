require 'rails_helper'

RSpec.describe TagsController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #tag_following_users" do
    it "@usersに要求されたuserを割り当てること" do
      tag = create(:tag)
      get :tag_following_users, params: {id: tag}
      expect(assigns(:users)).to match_array(tag.tag_following_users)
    end

    it "stocking_usersテンプレートを表示すること" do
      tag = create(:tag)
      get :tag_following_users, params: {id: tag}
      expect(response).to render_template :tag_following_users
    end
  end
end
