require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) do
    User.new({
                 name: name,
                 email: email,
                 password: password,
                 password_confirmation: password_confirmation})
  end
  let(:name) {""}
  let(:email) {""}
  let(:password) {""}
  let(:password_confirmation) {""}

  describe "前処理チェック" do
    context "有効なUserファクトリを持つ" do
      it "OK" do
        expect(build :user_michael).to be_valid
      end
    end
  end

  describe "新規登録パターン" do
    context "通常登録" do
      it "ユーザー名とメールアドレスとパスワードがあれば有効" do
        user = FactoryBot.build(:user_michael)
        expect(user).to be_valid
      end
    end

    describe "必須チェック" do
      context "ユーザー名がない" do
        let(:name) {nil}

        it "必須エラー" do
          user.valid?
          expect(user.errors[:name]).to include("を入力してください")
        end
      end

      context "メールアドレスがない" do
        let(:email) {nil}

        it "必須エラー" do
          user.valid?
          expect(user.errors[:email]).to include("を入力してください")
        end
      end

      context "パスワードがない" do
        let(:password) {nil}

        it "必須エラー" do
          user.valid?
          expect(user.errors[:password]).to include("を入力してください")
        end
      end
    end

    describe "不正チェック" do
      context "パスワードとパスワード（確認）が一致しない" do
        let(:name) {"jameson"}
        let(:email) {"jameson.chegilon.info@gmail.com"}
        let(:password) {"samplepass"}
        let(:password_confirmation) {"samplepass2"}

        it "パスワード不一致エラー" do
          user.valid?
          expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
        end
      end

      describe "フォーマットチェック" do
        context "ユーザー名に記号が含まれる" do
          let(:name) {"test@user"}
          it "フォーマットエラー" do
            user.valid?
            expect(user.errors[:name]).to include("英文字のみが使用できます")
          end
        end

        context "メールアドレスに@マークがない" do
          let(:email) {"sample.chegilon.infogmail.com"}
          it "フォーマットエラー" do
            user.valid?
            expect(user.errors[:email]).to include("は不正な値です")
          end
        end
      end

      describe "文字数オーバーチェック" do
        context "ユーザー名が20文字" do
          it "OK" do
            user = FactoryBot.build(:user_michael, name: "a" * 20)
            expect(user).to be_valid
          end
        end
        context "ユーザー名が21文字" do
          let(:name) {"a" * 21}
          it "文字数オーバー" do
            user.valid?
            expect(user.errors[:name]).to include("は20文字以内で入力してください")
          end
        end

        context "メールアドレスが255文字" do
          it "OK" do
            user = FactoryBot.build(:user_michael, email: "a" * 245 + "@gmail.com")
            expect(user).to be_valid
          end
        end
        context "メールアドレスが256文字" do
          let(:email) {"a" * 246 + "@gmail.com"}
          it "文字数オーバー" do
            user.valid?
            expect(user.errors[:email]).to include("は255文字以内で入力してください")
          end
        end
      end
    end

    describe "重複チェック" do
      context "メールアドレスが、すでに登録済みのメールアドレス" do
        let(:name) {"hack"}
        let(:email) {"michael.chegilon.info@gmail.com"}
        let(:password) {"samplepass"}

        before do
          FactoryBot.create(:user_michael)
        end

        it "重複メールアドレスなら無効" do
          user.valid?
          expect(user.errors[:email]).to include("はすでに存在します")
        end
      end
    end
  end

  describe "更新パターン" do
    before do
      FactoryBot.create(:user_michael)
    end
    describe "文字数オーバーチェック" do
      context "サイトURLが2000文字" do
        it "OK" do
          user_update = User.find_by(name: "michael")
          user_update.site_url = "https://" + "a" * 1992
          expect(user_update).to be_valid
        end
      end
      context "サイトURLが2001文字" do
        it "文字数オーバー" do
          user_update = User.find_by(name: "michael")
          user_update.site_url = "https://" + "a" * 1993
          user_update.valid?
          expect(user_update.errors[:site_url]).to include("は2000文字以内で入力してください")
        end
      end
    end
  end

  describe "メソッドチェック" do
    context "to_paramを呼び出す" do
      let(:name) {"michael"}
      let(:email) {"michael.chegilon.info@gmail.com"}
      let(:password) {"samplepass"}
      let(:password_confirmation) {"samplepass"}

      it "URLにはidではなく、ユーザー名を表示する" do
        expect(user.to_param).to eq "michael"
      end
    end
  end
end
