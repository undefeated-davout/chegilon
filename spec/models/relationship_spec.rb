require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe "前処理チェック" do
    context "有効なUserファクトリを持つ" do
      it "OK" do
        expect(build :user_vageena).to be_valid
      end

      it "OK" do
        expect(build :user_maxwell).to be_valid
      end
    end

    context "有効なRlationshipファクトリを持つ" do
      it "OK" do
        expect(FactoryBot.build(:relationship)).to be_valid
      end
    end
  end

  describe "新規登録パターン" do
    context "通常登録" do
      it "OK" do
        relationship = FactoryBot.build(:relationship)
        expect(relationship).to be_valid
      end
    end
  end
end
