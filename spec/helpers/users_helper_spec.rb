require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
  let(:user) {create :user_michael}

  describe "gravatar_forメソッド" do
    context "size指定なしの時" do
      it "size=80を返す" do
        expect(gravatar_for(user).include?("s=80")).to be_truthy
      end
    end

    context "size指定40の時" do
      it "size=40を返す" do
        expect(gravatar_for(user, size: 40).include?("s=40")).to be_truthy
      end
    end
  end
end
