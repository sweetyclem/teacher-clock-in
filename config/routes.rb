Rails.application.routes.draw do
  devise_for :teachers
  authenticate :teacher do
    resources :clock_ins
  end
  
  root 'clock_ins#index'
end
