Rails.application.routes.draw do
  root "pages#home"

  resource :sessions, only: %i[create destroy] # session為在server中，對應cookie的，來認定使用者登入狀態
  resource :users, except: %i[new destroy] do
    get "sign_up", action: "new"
    get "sign_in"
  end
  resources :resumes

  get "/about", to: "pages#about"
  get "/contact", to: "pages#contact"
end
