require 'rails_helper'

RSpec.describe ItemsController, type: :controller do

  describe "GET #index" do
    it "@itemsに要求されたItemを割り当てること" do
      items = Item.all
      get :index
      expect(assigns(:items)).to match_array(items)
    end

    it "indexテンプレートを表示すること" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    it "@itemに要求されたItemを割り当てること" do
      item = create(:item)
      get :show, params: {id: item}
      expect(assigns(:item)).to eq item
    end

    it "showテンプレートを表示すること" do
      item = create(:item)
      get :show, params: {id: item}
      expect(response).to render_template :show
    end
  end

  describe "GET #history" do
    it "@itemに要求されたItemを割り当てること" do
      item = create(:item)
      get :history, params: {id: item}
      expect(assigns(:item)).to eq item
    end

    it "historyテンプレートを表示すること" do
      item = create(:item)
      get :history, params: {id: item}
      expect(response).to render_template :history
    end
  end

  describe "GET #new" do
    context "ログアウト時" do
      it "アクセスを拒否すること（ログインページヘ）" do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログイン時" do
      before :each do
        login_user
      end
      it "@itemに要求されたItemでnewすること" do
        get :new
        expect(assigns(:item)).to be_a_new(Item)
      end

      it "newテンプレートを表示すること" do
        get :new
        expect(response).to render_template :new
      end
    end
  end

  describe "GET #create" do
    # it "returns http success" do
    #   get :create
    #   expect(response).to be_successful
    # end
  end

  describe "GET #edit" do
    # it "returns http success" do
    #   get :edit
    #   expect(response).to be_successful
    # end
  end

  describe "GET #update" do
    # it "returns http success" do
    #   get :update
    #   expect(response).to be_successful
    # end
  end

  describe "GET #stocking_users" do
    it "@usersに要求されたuserを割り当てること" do
      item = create(:item)
      get :stocking_users, params: {id: item}
      expect(assigns(:users)).to match_array(item.item_stocking_users)
    end

    it "stocking_usersテンプレートを表示すること" do
      item = create(:item)
      get :stocking_users, params: {id: item}
      expect(response).to render_template :stocking_users
    end
  end

  describe "GET #api_markdown" do
    it "returns http success" do
      get :api_markdown
      expect(response).to be_successful
    end
  end

  describe "GET #search" do
    # it "@itemに要求されたitemを割り当てること" do
    #   item_test = create(:item_test, content: "test本文")
    #   item_job = create(:item_job, content: "job本文")
    #   get :search, params: { sort_type: "関連度順", q: "test" }
    #   expect(assigns(:items_search_result).results.count).to eq(1)
    # end

    it "searchテンプレートを表示すること" do
      item = create(:item)
      get :search, params: {id: item}
      expect(response).to render_template :search
    end
  end
end
