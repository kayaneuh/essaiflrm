Rails.application.routes.draw do
  devise_for :users, :path=>'',
  :path_names=>{:sign_in=>'login',:sign_out=>'logout',:edit=>'profile'},
  :controllers=>{:registrations=>'registrations'}

  root 'pages#home'
  get 'pages/home'
resources :users, only: [ :show]
resources :rooms
resources :rooms do
            resources :reservations, only: [:create]
            resources :reviews, only: [:create, :destroy]
   end
resources :photos
get '/preload' => 'reservations#preload'
get '/preview' => 'reservations#preview'
get '/your_trips' => 'reservations#your_trips'
get '/your_reservations' => 'reservations#your_reservations'

get '/search' => 'pages#search'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
