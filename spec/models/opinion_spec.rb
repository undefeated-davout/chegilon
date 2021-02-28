require 'rails_helper'

RSpec.describe Opinion, type: :model do
  let(:opinion) do
    Opinion.new({content: content})
  end
  let(:content) {""}

  describe "前処理チェック" do
    context "有効なOpinionファクトリを持つ" do
      it "OK" do
        expect(FactoryBot.build(:opinion)).to be_valid
      end
    end
  end

  describe "新規登録パターン" do
    context "通常登録" do
      it "OK" do
        opinion = FactoryBot.build(:opinion)
        expect(opinion).to be_valid
      end
    end

    describe "必須チェック" do
      context "本文がない" do
        let(:content) {nil}

        it "必須エラー" do
          opinion.valid?
          expect(opinion.errors[:content]).to include("を入力してください")
        end
      end
    end

    describe "不正チェック" do
      describe "フォーマットチェック" do
      end

      describe "文字数オーバーチェック" do
        context "本文が1024文字" do
          it "OK" do
            opinion = FactoryBot.build(:opinion, content: "a" * 1024)
            expect(opinion).to be_valid
          end
        end
        context "本文が1025文字" do
          let(:content) {"a" * 1025}
          it "文字数オーバー" do
            opinion.valid?
            expect(opinion.errors[:content]).to include("は1024文字以内で入力してください")
          end
        end
      end
    end

    describe "重複チェック" do
    end
  end
end
