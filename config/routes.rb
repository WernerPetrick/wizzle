Rails.application.routes.draw do
  get "communities/index"
  get "communities/show"
  get "communities/new"
  get "communities/create"
  get "communities/edit"
  get "communities/update"
  constraints subdomain: 'blog' do
    scope module: 'blog' do
      resources :posts, only: [:index, :show]
      root to: 'posts#index', as: :blog_root
    end
  end

  resources :communities, only: [:index, :show, :new, :create, :edit, :update] do
    member do
      get :members
    end
  end

  namespace :admin do
    resources :image_uploads, only: [:create]
    resources :blog_posts
  end

  get "shared_wishlists/create"
  get "shared_wishlists/destroy"
  resource :profile, only: [:show, :update]
  resources :users, controller: "users", only: [:create, :new]
  resources :friends, only: [:index, :create] do
    member do
      patch :accept
      delete :decline
    end
  end
  resources :wishlists do
    resources :shared_wishlists, only: [:create, :destroy]
    member do
      patch :add_items
    end
    resources :wishlist_items, only: [:new, :create, :edit, :update, :destroy] do
      member do
        patch :mark_bought
        patch :unmark_bought
      end
      resources :wishlist_item_notes, only: [:create] do
        member do
          patch :reply
        end
      end
    end
  end
  get "/accept_invitation", to: "invitations#accept", as: :accept_invitation
  get "friends_wishlists", to: "wishlists#friends", as: :friends_wishlists
  get "questions", to: "questions#index", as: :questions
  get "how_it_works", to: "pages#how_it_works", as: :how_it_works
  get "users/:id", to: "users#show", as: :user
  get "/w/:token", to: "wishlists#public_show", as: :public_wishlist
  root "pages#index"
end
