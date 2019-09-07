Rails.application.routes.draw do
  devise_for :teachers, controllers: { registrations: 'teachers/registrations' }
  authenticate :teacher do
    resources :clock_ins
  end
  
  root 'clock_ins#index'
end
