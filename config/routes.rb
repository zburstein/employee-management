Rails.application.routes.draw do

  namespace :admin do
    get 'manager/dashboard', to: "managers#dashboard"
    resources :employees, only: [:index, :show, :edit, :update]
    resources :shifts
    resources :weeks, only: [:show]
    resources :weekly_payrolls, only: [:show, :create]
    resources :positions, only: [:index, :new, :edit, :create, :update]
    resources :tip_pools, only: :show
    resources :sales, except: [:show, :index]
    get '/shift/:id/sales', to: "shifts#show" #maybe instead route this to shift show when I am done
  end


  #root if authenticated
  authenticated :employee do
    root 'employees#dashboard', as: :authenticated_root
  end

  #get 'tips/show'
  resources :tips, only: [:show]
  resources :sales, only: [:create]


  get 'employees/dashboard'
  post '/clock_in/:id', to: 'shifts#create', as: "clock_in"
  patch '/clock_out/:id', to: 'shifts#clock_out', as: "clock_out"


  devise_for :employees, path_names: { sign_in: 'login', sign_out: 'logout', sign_up: "register"}, controllers: {registrations: "employees/registrations"}
  as :employee do
    get 'login', to: 'devise/sessions#new'
    delete 'logout', to: 'devise/sessions#destroy'
    root to: "devise/sessions#new"
    #get "/admin/employee/register" => "devise/registrations#new", as: "register_employee" # custom path to login/sign_in
  end



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
