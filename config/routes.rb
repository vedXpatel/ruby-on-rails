# config/routes.rb

Rails.application.routes.draw do
  namespace :admin do
    get 'date_search/search'
    post 'date_search/search'
    root 'date_search#search'
  end
end
