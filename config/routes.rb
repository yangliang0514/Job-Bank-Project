Rails.application.routes.draw do
  root "pages#home"

  resource :sessions, only: %i[create destroy] # session為在server中，對應cookie的，來認定使用者登入狀態

  # set the change language controller and path
  get "/lang/:lang", to: "locale#change", as: "locale"

  resource :users, except: %i[new destroy] do
    get "sign_up", action: "new"
    get "sign_in"
  end

  # 一個resume可以有好幾個comments，只有create時需要建立關聯，所以只有在create的時候需要nested route
  resources :resumes do
    # resources :comments, only: %i[create]
    member { post :like }
    resources :comments, shallow: true, only: %i[create edit update destroy]
  end

  # create routes for APIs
  # /api/v1/resumes/:id/sort
  namespace :api do
    namespace :v1 do
      resources :resumes, only: [] do
        member { patch :sort }
      end
    end
  end

  # 不需要nest在resume裡面的部分，直接對那個comment做的動作，或直接用上面那個shallow既可以有一樣的效果
  # resources :comment, only: %i[edit update destroy]

  get "/about", to: "pages#about"
  get "/contact", to: "pages#contact"
end
