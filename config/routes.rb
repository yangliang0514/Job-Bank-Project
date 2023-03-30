Rails.application.routes.draw do
  root "pages#home"

  resource :user, except: %i[new destroy] do
    get "/sign_up", action: "new"
  end
  resources :resumes

  get "/about", to: "pages#about"
  get "/contact", to: "pages#contact"
end
