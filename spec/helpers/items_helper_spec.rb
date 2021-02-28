require 'rails_helper'

RSpec.describe ItemsHelper, type: :helper do
  let(:item) {create :item}

  describe "markdownメソッド" do
    context "textがnilの時" do
      it "空白を返す" do
        expect(markdown(nil)).to eq ""
      end
    end

    context "textが「よろしく」の時" do
      it "「<p>よろしく</p>\n」を返す" do
        expect(markdown("よろしく")).to eq "<p>よろしく</p>\n"
      end
    end
  end

end
