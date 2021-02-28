Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'check' => 'application#check'

  # --- Devise ---
  devise_for :users, :controllers => {
      :registrations => 'users/registrations'
  }


  # --- Pagination ---
  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end


  # --- Static pages ---
  root 'utility_pages#top'
  get 'home' => 'utility_pages#home'
  get 'help' => 'utility_pages#help'
  get 'about' => 'utility_pages#about'
  get 'tos' => 'utility_pages#tos'
  get 'privacy' => 'utility_pages#privacy'


  # --- Utilities ---
  get 'popular' => 'utility_pages#popular'


  # --- Opinions ---
  resources :opinions, :concerns => :paginatable, only: [:new, :create]

  # --- Contacts ---
  resources :contacts, :concerns => :paginatable, only: [:new, :create]


  # --- Users ---
  resources :users, :concerns => :paginatable do
    member do
      get :following, :followers, :like_comments,
          :stock_items, :follow_tags, :items, :comments, :contributions
    end
    get "following/page/:page", action: :following, on: :member
    get "followers/page/:page", action: :followers, on: :member
    get "like_comments/page/:page", action: :like_comments, on: :member
    get "stock_items/page/:page", action: :stock_items, on: :member
    get "follow_tags/page/:page", action: :follow_tags, on: :member
    get "items/page/:page", action: :items, on: :member
    get "comments/page/:page", action: :comments, on: :member
    get "contributions/page/:page", action: :contributions, on: :member
  end

  resources :relationships, only: [:create, :destroy]


  # --- Items ---
  resources :items, :concerns => :paginatable, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    member do
      get :stocking_users
      get :liking_users
      get :history
    end
    get "stocking_users/page/:page", action: :stocking_users, on: :member
    get "liking_users/page/:page", action: :liking_users, on: :member
    get "history/page/:page", action: :history, on: :member
  end

  post 'api_markdown' => 'items#api_markdown'

  get 'search' => 'items#search'


  # --- Tags ---
  resources :tags, only: :index
  get 'tag_following_users' => 'tags#tag_following_users'


  # --- Comments ---
  resources :comments, :concerns => :paginatable, only: [:create, :edit, :update, :destroy] do
    member do
      get :liking_users
    end
    get "page/:page", action: :liking_users, on: :member
  end


  # --- Likes, Stocks, follows ---
  post 'comment_like/:comment_id' => 'comment_likes#create', as: 'comment_like'
  delete 'comment_unlike/:comment_id' => 'comment_likes#destroy', as: 'comment_unlike'

  post 'item_stock/:item_id' => 'item_stocks#create', as: 'item_stock'
  delete 'item_unstock/:item_id' => 'item_stocks#destroy', as: 'item_unstock'

  post 'tag_follow/:tag_id' => 'tag_follows#create', as: 'tag_follow'
  delete 'tag_unfollow/:tag_id' => 'tag_follows#destroy', as: 'tag_unfollow'

end
