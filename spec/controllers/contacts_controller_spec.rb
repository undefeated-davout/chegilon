require 'rails_helper'

RSpec.describe ContactsController, type: :controller do

  describe "GET #new" do
    it "@contactに要求されたContactでnewすること" do
      get :new
      expect(assigns(:contact)).to be_a_new(Contact)
    end

    it "newテンプレートを表示すること" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "GET #create" do
    # context "正しい値で登録しようとしたとき" do
    #   it "データベースに新しいContactを保存すること" do
    #     expect{
    #       post :create, params: { contact: attributes_for(:contact) }
    #     }.to change(Contact, :count).by(1)
    #   end

    #   it "rootにredirectすること" do
    #     post :create, params: { contact: attributes_for(:contact) }
    #     expect(response).to redirect_to root_path
    #   end
    # end

    # context "不正な値で登録しようとしたとき" do
    #   it "データベースに新しいContactを保存しないこと" do
    #     expect{
    #       post :create, params: { contact: attributes_for(:contact, content: nil) }
    #     }.not_to change(Contact, :count)
    #   end

    #   it "newテンプレートを表示すること" do
    #     post :create, params: { contact: attributes_for(:contact, content: nil) }
    #     expect(response).to render_template :new
    #   end
    # end
  end
end
