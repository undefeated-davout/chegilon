require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe "GET #create" do
    # it "returns http success" do
    #   get :create
    #   expect(response).to be_successful
    # end
  end

  describe "GET #edit" do
    # it "returns http success" do
    #   get :edit
    #   expect(response).to be_successful
    # end
  end

  describe "GET #update" do
    # it "returns http success" do
    #   get :update
    #   expect(response).to be_successful
    # end
  end

  describe "GET #destroy" do
    # before :each do
    #   @comment = create(:comment)
    # end

    # it "commentが削除されること" do
    #   expect{
    #     delete :destroy, id: @comment
    #   }.to change(Comment,:count).by(-1)
    # end

    # it "元のページにredirectされること" do
    #   delete :destroy, id: @comment
    #   expect(response).to redirect_to request.referrer
    # end
  end

  describe "GET #liking_users" do
    it "@usersに要求されたuserを割り当てること" do
      comment = create(:comment)
      get :liking_users, params: {id: comment}
      expect(assigns(:users)).to match_array(comment.comment_liking_users)
    end

    it "liking_usersテンプレートを表示すること" do
      comment = create(:comment)
      get :liking_users, params: {id: comment}
      expect(response).to render_template :liking_users
    end
  end
end
