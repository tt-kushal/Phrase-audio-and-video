Rails.application.routes.draw do
  defaults format: :json do
    resources :videos, only: [:create, :show]
  end
end