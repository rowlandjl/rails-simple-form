Rails.application.routes.draw do
  resources :menu_items do
    resources :comments, only: [:create]
  end

  root "menu_items#index"
end
