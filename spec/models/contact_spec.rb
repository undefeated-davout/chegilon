require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:contact) do
    Contact.new({
                    email: email,
                    contact_category: contact_category,
                    title: title,
                    content: content})
  end
  let(:email) {""}
  let(:contact_category) {FactoryBot.create(:contact_category_chegilon)}
  let(:title) {""}
  let(:content) {""}

  describe "前処理チェック" do
    context "有効なContactCategoryファクトリを持つ" do
      it "OK" do
        expect(FactoryBot.build(:contact_category_chegilon)).to be_valid
      end

      it "OK" do
        expect(FactoryBot.build(:contact_category_withdrawal)).to be_valid
      end
    end

    context "有効なContactファクトリを持つ" do
      it "OK" do
        expect(FactoryBot.build(:contact)).to be_valid
      end
    end
  end

  describe "新規登録パターン" do
    context "通常登録" do
      it "OK" do
        contact = FactoryBot.build(:contact)
        expect(contact).to be_valid
      end
    end

    describe "必須チェック" do
      context "メールアドレスがない" do
        let(:email) {nil}

        it "必須エラー" do
          contact.valid?
          expect(contact.errors[:email]).to include("を入力してください")
        end
      end

      context "カテゴリーがない" do
        let(:contact_category) {nil}

        it "必須エラー" do
          contact.valid?
          expect(contact.errors[:contact_category]).to include("を入力してください")
        end
      end

      context "タイトルがない" do
        let(:title) {nil}

        it "必須エラー" do
          contact.valid?
          expect(contact.errors[:title]).to include("を入力してください")
        end
      end

      context "本文がない" do
        let(:content) {nil}

        it "必須エラー" do
          contact.valid?
          expect(contact.errors[:content]).to include("を入力してください")
        end
      end
    end

    describe "不正チェック" do
      describe "フォーマットチェック" do
        context "メールアドレスに@マークがない" do
          let(:email) {"sample.chegilon.infogmail.com"}
          it "フォーマットエラー" do
            contact.valid?
            expect(contact.errors[:email]).to include("は不正な値です")
          end
        end
      end

      describe "文字数オーバーチェック" do
        context "メールアドレスが255文字" do
          it "OK" do
            contact = FactoryBot.build(:contact, email: "a" * 245 + "@gmail.com")
            expect(contact).to be_valid
          end
        end
        context "メールアドレスが256文字" do
          let(:email) {"a" * 246 + "@gmail.com"}
          it "文字数オーバー" do
            contact.valid?
            expect(contact.errors[:email]).to include("は255文字以内で入力してください")
          end
        end

        context "タイトルが255文字" do
          it "OK" do
            contact = FactoryBot.build(:contact, title: "a" * 255)
            expect(contact).to be_valid
          end
        end
        context "タイトルが256文字" do
          let(:title) {"a" * 256}
          it "文字数オーバー" do
            contact.valid?
            expect(contact.errors[:title]).to include("は255文字以内で入力してください")
          end
        end

        context "本文が1024文字" do
          it "OK" do
            contact = FactoryBot.build(:contact, content: "a" * 1024)
            expect(contact).to be_valid
          end
        end
        context "本文が1025文字" do
          let(:content) {"a" * 1025}
          it "文字数オーバー" do
            contact.valid?
            expect(contact.errors[:content]).to include("は1024文字以内で入力してください")
          end
        end
      end
    end

    describe "重複チェック" do
    end
  end
end
