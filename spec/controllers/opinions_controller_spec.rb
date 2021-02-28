require 'rails_helper'

RSpec.describe OpinionsController, type: :controller do

  describe "GET #new" do
    it "@opinionに要求されたOpinionでnewすること" do
      get :new
      expect(assigns(:opinion)).to be_a_new(Opinion)
    end

    it "newテンプレートを表示すること" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "正しい値で登録しようとしたとき" do
      it "データベースに新しいOpinionを保存すること" do
        expect {
          post :create, params: {opinion: attributes_for(:opinion)}
        }.to change(Opinion, :count).by(1)
      end

      it "rootにredirectすること" do
        post :create, params: {opinion: attributes_for(:opinion)}
        expect(response).to redirect_to root_path
      end
    end

    context "不正な値で登録しようとしたとき" do
      it "データベースに新しいOpinionを保存しないこと" do
        expect {
          post :create, params: {opinion: attributes_for(:opinion, content: nil)}
        }.not_to change(Opinion, :count)
      end

      it "newテンプレートを表示すること" do
        post :create, params: {opinion: attributes_for(:opinion, content: nil)}
        expect(response).to render_template :new
      end
    end
  end
end
