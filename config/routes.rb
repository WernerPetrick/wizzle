Rails.application.routes.draw do

  get "roadmap_items/index"
  constraints subdomain: 'blog' do
    scope module: 'blog' do
      resources :posts, only: [:index, :show]
      root to: 'posts#index', as: :blog_root
    end
  end

  resources :communities, only: [:index, :show, :new, :create, :edit, :update] do
    member do
      get :members
      delete :remove_avatar
    end
    resources :community_invitations, only: [:new, :create]
    resources :community_memberships, only: [:destroy, :update]
    resources :community_events, only: [:show, :new, :create, :edit, :update, :destroy]
    resources :secret_santas, except: [:index] do
      member do
        patch :generate_assignments
      end
    end
  end

  resources :community_invitations, only: [] do
    member do
      patch :accept
      patch :decline
      get :accept
      get :decline
    end
  end

  namespace :admin do
    resources :image_uploads, only: [:create]
    resources :blog_posts
  end

  namespace :admin do
    resources :roadmap_items do
      collection do
        post :sort
      end
    end
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
  get "feature_requests", to: "pages#feature_requests", as: :feature_requests
  post "feature_requests", to: "pages#submit_feature_request"
  get "questions", to: "questions#index", as: :questions
  get "how_it_works", to: "pages#how_it_works", as: :how_it_works
  get "about", to: "pages#about", as: :about
  get "users/:id", to: "users#show", as: :user
  get "/w/:token", to: "wishlists#public_show", as: :public_wishlist
  get '/roadmap', to: 'roadmap_items#index', as: :roadmap
  root "pages#index"
end