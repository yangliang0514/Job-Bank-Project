Rails.application.routes.draw do
  root "pages#index"

  get "/resumes", to: "resumes#index"
  post "/resumes", to: "resumes#create"
  get "resumes/new", to: "resumes#new", as: "new_resume"
  get "/about", to: "pages#about"
  get "/contact", to: "pages#contact"
end
