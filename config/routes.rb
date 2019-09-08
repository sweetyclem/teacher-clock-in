Rails.application.routes.draw do
  devise_for :teachers, controllers: { registrations: 'teachers/registrations' }
  authenticate :teacher do
    resources :clock_ins
    post 'end', to: 'clock_ins#end', as: :end_clock_in
  end
  
  root 'clock_ins#index'
end
