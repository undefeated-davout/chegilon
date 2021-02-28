require 'rails_helper'

RSpec.describe UtilityPagesController, type: :controller do

  describe "GET #top" do
    context "ログアウト時" do
      it "topテンプレートを表示すること" do
        get :top
        expect(response).to render_template :top
      end
    end

    context "ログイン時" do
      before :each do
        login_user
      end
      it "homeへredirectすること" do
        get :top
        expect(response).to redirect_to home_path
      end
    end
  end

  describe "GET #home" do
    context "ログアウト時" do
      it "rootへredirectすること" do
        get :home
        expect(response).to redirect_to root_path
      end
    end

    context "ログイン時" do
      before :each do
        login_user
      end
      it "topテンプレートを表示すること" do
        get :home
        expect(response).to render_template :home
      end
    end
  end

  describe "GET #popular" do
    it "popularテンプレートを表示すること" do
      get :popular
      expect(response).to render_template :popular
    end

    context "ログアウト時" do
      it "すべてのuserのpopular情報を表示すること" do
        user = User.new
        get :popular
        expect(assigns(:popular_items)).to eq user.popular_items
      end
    end
    context "ログイン時" do
      before :each do
        login_user
      end
      it "current_userのpopular情報を表示すること" do
        user = FactoryBot.build(:user)
        get :popular
        expect(assigns(:popular_items)).to eq user.popular_items
      end
    end
  end

  describe "GET #about" do
    it "aboutテンプレートを表示すること" do
      get :about
      expect(response).to render_template :about
    end
  end

  describe "GET #help" do
    it "helpテンプレートを表示すること" do
      get :help
      expect(response).to render_template :help
    end
  end

  describe "GET #tos" do
    it "tosテンプレートを表示すること" do
      get :tos
      expect(response).to render_template :tos
    end
  end

  describe "GET #privacy" do
    it "privacyテンプレートを表示すること" do
      get :privacy
      expect(response).to render_template :privacy
    end
  end
end
