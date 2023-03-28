Rails.application.routes.draw do
  root "pages#index"

  get "/resumes", to: "resumes#index"
  get "/resume/:id", to: "resumes#show", as: "show_resume"
  post "/resumes", to: "resumes#create"
  get "resumes/new", to: "resumes#new", as: "new_resume"
  get "/about", to: "pages#about"
  get "/contact", to: "pages#contact"
end
