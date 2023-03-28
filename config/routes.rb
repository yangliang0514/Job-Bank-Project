Rails.application.routes.draw do
  root "pages#home"
  get "/resumes", to: "resumes#index"
  get "resumes/new", to: "resumes#new", as: "new_resume"
  get "/resumes/:id", to: "resumes#show", as: "resume"
  get "/resumes/:id/edit", to: "resumes#edit", as: "edit_resume"
  patch "/resumes/:id", to: "resumes#update"
  delete "resumes/:id", to: "resumes#destroy"
  post "/resumes", to: "resumes#create"
  get "/about", to: "pages#about"
  get "/contact", to: "pages#contact"
end
