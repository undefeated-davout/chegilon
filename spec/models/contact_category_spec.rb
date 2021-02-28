require 'rails_helper'

RSpec.describe ContactCategory, type: :model do
  let(:contact_category) do
    ContactCategory.new(
        output_number: output_number,
        name: name)
  end
  let(:output_number) {""}
  let(:name) {""}

  describe "前処理チェック" do
    context "有効なContactCategoryファクトリを持つ" do
      it "OK" do
        expect(FactoryBot.build(:contact_category)).to be_valid
      end
    end
  end

  describe "新規登録パターン" do
    context "通常登録" do
      it "OK" do
        contact_category = FactoryBot.build(:contact_category)
        expect(contact_category).to be_valid
      end
    end

    describe "必須チェック" do
      context "出力番号がない" do
        let(:output_number) {nil}

        it "必須エラー" do
          contact_category.valid?
          expect(contact_category.errors[:output_number]).to include("を入力してください")
        end
      end

      context "カテゴリー名がない" do
        let(:name) {nil}

        it "必須エラー" do
          contact_category.valid?
          expect(contact_category.errors[:name]).to include("を入力してください")
        end
      end
    end

    describe "不正チェック" do
      describe "文字数オーバーチェック" do
        context "出力番号が0" do
          it "OK" do
            contact_category = FactoryBot.build(:contact_category, output_number: 0)
            expect(contact_category).to be_valid
          end
        end
        context "出力番号が10" do
          it "OK" do
            contact_category = FactoryBot.build(:contact_category, output_number: 10)
            expect(contact_category).to be_valid
          end
        end
        context "出力番号が−1" do
          let(:output_number) {-1}
          it "文字数オーバー" do
            contact_category.valid?
            expect(contact_category.errors[:output_number]).to include("は0以上の値にしてください")
          end
        end
        context "出力番号が11" do
          let(:output_number) {11}
          it "文字数オーバー" do
            contact_category.valid?
            expect(contact_category.errors[:output_number]).to include("は10以下の値にしてください")
          end
        end

        context "カテゴリー名が50文字" do
          it "OK" do
            contact_category = FactoryBot.build(:contact_category, name: "a" * 50)
            expect(contact_category).to be_valid
          end
        end
        context "カテゴリー名が51文字" do
          let(:name) {"a" * 51}
          it "文字数オーバー" do
            contact_category.valid?
            expect(contact_category.errors[:name]).to include("は50文字以内で入力してください")
          end
        end
      end
    end

    describe "重複チェック" do
    end
  end
end
