require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do

  describe "GET #create" do
    # context "正しい値で登録しようとしたとき" do
    #   it "データベースに新しいRelationshipを保存すること" do
    #     expect{
    #       post :create, params: { relationship: attributes_for(:relationship) }
    #     }.to change(Relationship, :count).by(1)
    #   end

    #   it "rootにredirectすること" do
    #     post :create, params: { relationship: attributes_for(:relationship) }
    #     expect(response).to redirect_to user_path(relationship.follower)
    #   end
    # end
  end

  describe "GET #destroy" do
    # it "returns http success" do
    #   get :destroy
    #   expect(response).to be_successful
    # end
  end
end
