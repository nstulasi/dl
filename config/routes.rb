SampleApp::Application.routes.draw do




  resources :default_policies

  resources :meta do 
    resources :resources
  end

  resources :resources

  resources :phases

  resources :projects do 
    resources :resources
  end

  resources :policies

  resources :events
  match '/generate_stream'=>'meta#generate_stream'
  match '/generate_structure'=>'meta#generate_structure'
  match '/generate_scenario'=>'meta#generate_scenario'
  match '/generate_space'=>'meta#generate_space'
  match '/generate_society'=>'meta#generate_society'
  match '/rake_tasks'=>'tasks#rake_tasks'
  match "phases/savesort" => 'phases#savesort'
  match "shippings_logs/recent"=> 'shipping_logs#recent'
  match '/articles(/:year(/:month))' => 'articles#index', :as => :articles, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}

  match '/events(/:year(/:month))' => 'events#index', :as => :articles, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}

  match '/tasks/calendar(/:year(/:month))' => 'tasks#view_calendar', :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
  
  match '/tasks/rake_tasks', :to => 'tasks#rake_tasks'
  
  resources :tasks do 
    resources :resources
  end
  get "sessions/new"

  resources :users 
    match '/users/:id/' => 'users#update', :format =>:json, :via => :put
  resources :sessions, :only => [:new,:create,:destroy]
  
  match "/tasks/index.js", :controller => 'tasks', :action => 'index', :format => :js
  get "users/new"
  match "/phases/make", :to=>'phases#make', :via => :post
  #get "pages/home" #automatically maps the URL pages/home to the action home in the Pages controller

  #get "pages/contact"
  
  #get "pages/about"
  match '/contact', :to => 'pages#contact'
  match '/about', :to => 'pages#about'
  match '/help', :to => 'pages#help'
  match '/signup', :to => 'users#new'
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  
  root :to => 'pages#home'
  
  match '/projects/new_user', :to=>'projects#new_user'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
