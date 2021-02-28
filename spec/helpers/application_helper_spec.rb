require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  let(:login_user) {create :user}
  let(:other_user) {create :user_michael}

  describe "full_titleメソッド" do
    context "ページタイトルが空白" do
      it "Chegilonを返す" do
        expect(full_title).to eq "Chegilon"
      end
    end

    context "ページタイトルが「ヘルプ」" do
      it "「ヘルプ | Chegilon」を返す" do
        expect(full_title("ヘルプ")).to eq "ヘルプ | Chegilon"
      end
    end
  end

  describe "current_user?メソッド" do
    context "自分のユーザーなら" do
      # ログインしてから
      before :each do
        login_user
      end
      it "trueを返す" do
        allow(helper).to receive(:current_user).and_return(login_user)
        expect(helper.current_user?(login_user)).to be_truthy
      end
    end

    context "他のユーザーなら" do
      # ログインしてから
      before :each do
        login_user
      end
      it "falseを返す" do
        allow(helper).to receive(:current_user).and_return(login_user)
        expect(helper.current_user?(other_user)).to be_falsey
      end
    end
  end

  describe "footer_display_page?メソッド" do
    context "ItemsControllerのnewメソッドの時" do
      it "trueを返す" do
        expect(footer_display_page?("items", "new")).to be_truthy
      end
    end

    context "ItemsControllerのeditメソッドの時" do
      it "trueを返す" do
        expect(footer_display_page?("items", "edit")).to be_truthy
      end
    end

    context "ItemsControllerのshowメソッドの時" do
      it "falseを返す" do
        expect(footer_display_page?("items", "show")).to be_falsey
      end
    end

    context "CommentsControllerのnewメソッドの時" do
      it "falseを返す" do
        expect(footer_display_page?("comments", "new")).to be_falsey
      end
    end
  end
end
