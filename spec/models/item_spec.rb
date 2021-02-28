require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:item) do
    Item.new({
                 title: title,
                 tag_list_entry: tag_list_entry,
                 content: content,
                 update_comment: update_comment,
                 create_user: FactoryBot.create(:user_michael),
                 update_user: FactoryBot.create(:user_jackson),
                 lock_version: 0
             })
  end
  let(:title) {""}
  let(:tag_list_entry) {""}
  let(:content) {""}
  let(:update_comment) {""}
  let(:create_user) {""}
  let(:update_user) {""}

  describe "前処理チェック" do
    context "有効なUserファクトリを持つ" do
      it "OK" do
        expect(FactoryBot.build(:user_michael)).to be_valid
      end

      it "OK" do
        expect(FactoryBot.build(:user_jackson)).to be_valid
      end
    end

    context "有効なItemファクトリを持つ" do
      it "OK" do
        expect(FactoryBot.build(:item)).to be_valid
      end
    end
  end

  describe "新規登録パターン" do
    context "通常登録" do
      it "OK" do
        item = FactoryBot.build(:item)
        expect(item).to be_valid
      end
    end

    describe "必須チェック" do
      context "タイトルがない" do
        let(:title) {nil}
        it "必須エラー" do
          item.valid?
          expect(item.errors[:title]).to include("を入力してください")
        end
      end

      context "タグがない" do
        let(:tag_list_entry) {nil}
        it "必須エラー" do
          item.valid?
          expect(item.errors[:tag_list_entry]).to include("を入力してください")
        end
      end

      context "本文がない" do
        let(:content) {nil}
        it "必須エラー" do
          item.valid?
          expect(item.errors[:content]).to include("を入力してください")
        end
      end
    end

    describe "不正チェック" do
      describe "文字数オーバーチェック" do
        context "タイトルが100文字" do
          it "OK" do
            item = FactoryBot.build(:item, title: "a" * 100)
            expect(item).to be_valid
          end
        end
        context "タイトルが101文字" do
          let(:title) {"a" * 101}
          it "文字数オーバー" do
            item.valid?
            expect(item.errors[:title]).to include("は100文字以内で入力してください")
          end
        end

        context "タグが100文字" do
          it "OK" do
            item = FactoryBot.build(:item, tag_list_entry: "a" * 100)
            expect(item).to be_valid
          end
        end
        context "タグタイトルが101文字" do
          let(:tag_list_entry) {"a" * 101}
          it "文字数オーバー" do
            item.valid?
            expect(item.errors[:tag_list_entry]).to include("は100文字以内で入力してください")
          end
        end

        context "本文が1048575文字" do
          it "OK" do
            item = FactoryBot.build(:item, content: "a" * 1048575)
            expect(item).to be_valid
          end
        end
        context "本文が1048576文字" do
          let(:content) {"a" * 1048576}
          it "文字数オーバー" do
            item.valid?
            expect(item.errors[:content]).to include("は1048575文字以内で入力してください")
          end
        end
      end
    end
  end

  describe "更新パターン" do
    describe "不正チェック" do
      describe "文字数オーバーチェック" do
        context "更新コメントが100文字" do
          it "OK" do
            item_update = create(:item)
            item_update.update_comment = "a" * 100
            expect(item_update).to be_valid
          end
        end
        context "更新コメントが101文字" do
          it "文字数オーバー" do
            item_update = create(:item)
            item_update.update_comment = "a" * 101
            item_update.valid?
            expect(item_update.errors[:update_comment]).to include("は100文字以内で入力してください")
          end
        end
      end
    end
  end
end
