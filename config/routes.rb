Rails.application.routes.draw do
  get "shared_wishlists/create"
  get "shared_wishlists/destroy"
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
  get "profile", to: "profiles#show", as: :profile
  get "friends_wishlists", to: "wishlists#friends", as: :friends_wishlists
  get "questions", to: "questions#index", as: :questions
  get "users/:id", to: "users#show", as: :user
  root "pages#index"
end