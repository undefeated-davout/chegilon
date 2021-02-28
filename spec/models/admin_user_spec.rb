require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  let(:admin_user) do
    AdminUser.new({
                      email: email,
                      password: password,
                      password_confirmation: password_confirmation})
  end
  let(:email) {""}
  let(:password) {""}
  let(:password_confirmation) {""}

  describe "前処理チェック" do
    context "有効なAdminUserファクトリを持つ" do
      it "OK" do
        expect(build :user_god).to be_valid
      end
    end
  end

  describe "新規登録パターン" do
    context "通常登録" do
      it "メールアドレスとパスワードがあれば有効" do
        admin_user = FactoryBot.build(:user_god)
        expect(admin_user).to be_valid
      end
    end

    describe "必須チェック" do
      context "メールアドレスがない" do
        let(:email) {nil}

        it "必須エラー" do
          admin_user.valid?
          expect(admin_user.errors[:email]).to include("を入力してください")
        end
      end

      context "パスワードがない" do
        let(:password) {nil}

        it "必須エラー" do
          admin_user.valid?
          expect(admin_user.errors[:password]).to include("を入力してください")
        end
      end
    end

    describe "不正チェック" do
      context "パスワードとパスワード（確認）が一致しない" do
        let(:email) {"jameson.chegilon.info@gmail.com"}
        let(:password) {"samplepass"}
        let(:password_confirmation) {"samplepass2"}

        it "パスワード不一致エラー" do
          admin_user.valid?
          expect(admin_user.errors[:password_confirmation]).to include("とPasswordの入力が一致しません")
        end
      end

      describe "フォーマットチェック" do
        context "メールアドレスに@マークがない" do
          let(:email) {"sample.chegilon.infogmail.com"}
          it "フォーマットエラー" do
            admin_user.valid?
            expect(admin_user.errors[:email]).to include("は不正な値です")
          end
        end
      end

      describe "文字数オーバーチェック" do
        context "メールアドレスが255文字" do
          it "OK" do
            admin_user = FactoryBot.build(:user_god, email: "a" * 245 + "@gmail.com")
            expect(admin_user).to be_valid
          end
        end
        context "メールアドレスが256文字" do
          let(:email) {"a" * 246 + "@gmail.com"}
          it "文字数オーバー" do
            admin_user.valid?
            expect(admin_user.errors[:email]).to include("は255文字以内で入力してください")
          end
        end
      end
    end

    describe "重複チェック" do
      context "メールアドレスが、すでに登録済みのメールアドレス" do
        let(:email) {"god.chegilon.info@gmail.com"}
        let(:password) {"samplepass"}
        let(:password_confirmation) {"samplepass"}

        before do
          FactoryBot.create(:user_god)
        end

        it "重複メールアドレスなら無効" do
          admin_user.valid?
          expect(admin_user.errors[:email]).to include("はすでに存在します")
        end
      end
    end
  end
end
