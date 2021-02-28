require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #index" do
    it "@usersに要求されたuserを割り当てること" do
      users = User.all
      get :index
      expect(assigns(:users)).to match_array(users)
    end

    it "indexテンプレートを表示すること" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    it "@userに要求されたuserを割り当てること" do
      user = create(:user)
      get :show, params: {id: user}
      expect(assigns(:user)).to eq user
    end

    it "showテンプレートを表示すること" do
      user = create(:user)
      get :show, params: {id: user}
      expect(response).to render_template :show
    end

    context "不正なUserが要求されたとき" do
      it "アクセスを拒否すること" do
        get :show, params: {id: "sample_not_exist"}
        expect(response).to redirect_to root_url
      end
    end
  end

  describe "GET #following" do
    it "@userに要求されたuserを割り当てること" do
      user = create(:user)
      get :following, params: {id: user}
      expect(assigns(:user)).to eq user
    end

    it "show_follow_usersテンプレートを表示すること" do
      user = create(:user)
      get :following, params: {id: user}
      expect(response).to render_template :show_follow_users
    end
  end

  describe "GET #followers" do
    it "@userに要求されたuserを割り当てること" do
      user = create(:user)
      get :followers, params: {id: user}
      expect(assigns(:user)).to eq user
    end

    it "show_follow_usersテンプレートを表示すること" do
      user = create(:user)
      get :followers, params: {id: user}
      expect(response).to render_template :show_follow_users
    end
  end

  describe "GET #follow_tags" do
    it "@userに要求されたuserを割り当てること" do
      user = create(:user)
      get :follow_tags, params: {id: user}
      expect(assigns(:user)).to eq user
    end

    it "show_follow_tagsテンプレートを表示すること" do
      user = create(:user)
      get :follow_tags, params: {id: user}
      expect(response).to render_template :show_follow_tags
    end
  end

  describe "GET #stock_items" do
    it "@userに要求されたuserを割り当てること" do
      user = create(:user)
      get :stock_items, params: {id: user}
      expect(assigns(:user)).to eq user
    end

    it "show_stock_itemsテンプレートを表示すること" do
      user = create(:user)
      get :stock_items, params: {id: user}
      expect(response).to render_template :show_stock_items
    end
  end

  describe "GET #items" do
    it "@userに要求されたuserを割り当てること" do
      user = create(:user)
      get :items, params: {id: user}
      expect(assigns(:user)).to eq user
    end

    it "show_itemsテンプレートを表示すること" do
      user = create(:user)
      get :items, params: {id: user}
      expect(response).to render_template :show_items
    end
  end

  describe "GET #comments" do
    it "@userに要求されたuserを割り当てること" do
      user = create(:user)
      get :comments, params: {id: user}
      expect(assigns(:user)).to eq user
    end

    it "show_commentsテンプレートを表示すること" do
      user = create(:user)
      get :comments, params: {id: user}
      expect(response).to render_template :show_comments
    end
  end

  describe "GET #contributions" do
    it "@userに要求されたuserを割り当てること" do
      user = create(:user)
      get :contributions, params: {id: user}
      expect(assigns(:user)).to eq user
    end

    it "show_contributionsテンプレートを表示すること" do
      user = create(:user)
      get :contributions, params: {id: user}
      expect(response).to render_template :show_contributions
    end
  end
end
