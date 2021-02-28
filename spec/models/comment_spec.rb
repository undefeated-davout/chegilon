require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) do
    Comment.new({
                    user: FactoryBot.create(:user_tom),
                    item: FactoryBot.create(:item),
                    content: content,
                    image: "",
                    remove_image: false,
                    image_cache: ""
                })
  end
  let(:user) {""}
  let(:item) {""}
  let(:content) {""}
  let(:image) {""}
  let(:remove_image) {""}
  let(:image_cache) {""}

  describe "前処理チェック" do
    context "有効なUserファクトリを持つ" do
      it "OK" do
        expect(FactoryBot.build(:user_tom)).to be_valid
      end
    end

    context "有効なItemファクトリを持つ" do
      it "OK" do
        expect(FactoryBot.build(:item)).to be_valid
      end
    end

    context "有効なCommentファクトリを持つ" do
      it "OK" do
        expect(FactoryBot.build(:comment)).to be_valid
      end
    end
  end

  describe "新規登録パターン" do
    context "通常登録" do
      it "OK" do
        comment = FactoryBot.build(:comment)
        expect(comment).to be_valid
      end
    end

    describe "必須チェック" do
      context "本文がない" do
        let(:content) {nil}
        it "必須エラー" do
          comment.valid?
          expect(comment.errors[:content]).to include("を入力してください")
        end
      end
    end

    describe "不正チェック" do
      describe "文字数オーバーチェック" do
        context "本文が255文字" do
          it "OK" do
            comment = FactoryBot.build(:comment, content: "a" * 255)
            expect(comment).to be_valid
          end
        end
        context "本文が256文字" do
          let(:content) {"a" * 256}
          it "文字数オーバー" do
            comment.valid?
            expect(comment.errors[:content]).to include("は255文字以内で入力してください")
          end
        end
      end
    end
  end

  describe "更新パターン" do
  end
end
