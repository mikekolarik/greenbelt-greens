Rails.application.routes.draw do

  get 'error_not_admin' => 'errors#error_not_admin', :as => 'not_admin'

  match 'api/*other', :controller => 'application', :action => 'handle_options_request', :constraints => {:method => 'OPTIONS'}, via: [:options]

  devise_for :users, controllers: { sessions: "users/sessions"}

  namespace :admin do
    root to: "intro_screen_blocks#index"
    resources :users do
      collection { post :switch_value }
      collection { get 'list' => 'users#list_of_admins' }
    end
    resources :meal_examples
    resources :referral_codes
    resources :dietary_goals
    resources :dietary_preferences
    resources :help_blocks
    resources :intro_screen_blocks
    resources :popover_contents
    resources :ingredients do
      collection { post :import }
    end
    resources :ingredient_categories do
      collection { post :import }
    end
    resources :meal_examples
    resources :zip_code_ranges
    resources :categories_groups
    resources :meal_types
  end

  namespace :api do
    get 'categories_groups/full_data' => 'categories_group#get_full_data'
    get 'ingredients' => 'ingredients#index'
    get 'meal_examples'         => 'meal_examples#index'
    get 'dietary_goals'         => 'dietary_goals#index'
    get 'dietary_preferences'   => 'dietary_preferences#index'
    get 'help_blocks'           => 'help_blocks#index'
    get 'intro'                 => 'intro#index'
    get 'meal_examples'         => 'meal_examples#index'
    get 'meal_types' => 'meal_types#index'
    get 'popover_contents' => 'popover_contents#index'
    post 'subscribe_new_user'   => 'subscribe_new_users#subscribe_user'
    post 'sign_up'               => 'sign_up#create'
    post 'check_if_user_exists' => 'sign_up#check_if_user_exists'

    post 'check_code_validity' => 'referral_codes#check_code_validity'
    devise_scope :user do
      post 'check_for_valid'    => 'zip_codes#check_for_valid', :as => 'check_for_valid'
      post 'registrations'      => 'registrations#create',      :as => 'register'
      post 'sessions'           => 'sessions#create',           :as => 'login'
      get 'get_first_delivery_date' => 'registrations#get_first_delivery_date'
    end
  end

  root 'admin/intro_screen_blocks#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
