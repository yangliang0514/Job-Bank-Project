Rails.application.routes.draw do
  get "/resumes", to: "resumes#index"
  get "resumes/new", to: "resumes#new"
  get "/about", to: "about#index"
  get "/contact", to: "about#contact"
end
