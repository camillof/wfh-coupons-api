Rails.application.routes.draw do
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope '/api' do
    resources :invitations, controller: 'rails_jwt_auth/invitations', only: [:create, :update]
    resource :session, controller: 'rails_jwt_auth/sessions', only: [:create, :destroy]
    resource :password, controller: 'rails_jwt_auth/passwords', only: [:create, :update]
    resource :confirmation, controller: 'rails_jwt_auth/confirmations', only: [:create, :update]
    resource :registration, controller: 'rails_jwt_auth/registrations', only: [:create, :update, :destroy]
  end

  namespace :api do
    
    resources :users
    resources :coupons do
      member do
        put 'approve'
        put 'reject'
      end
    
    end
  end
  
end
