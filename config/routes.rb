Rails.application.routes.draw do
  resources :reservations, except: [:show]
  get 'reservations/:id/note', to: 'reservations#note', as: 'note_reservation'
  match 'reservations/check' => 'reservations#check', via: [:get, :post]

  resources :tables, only: [:index, :create, :update, :destroy]
  get 'tables/restrict' => 'tables#restrict'

  devise_for :users
  get 'users', to: 'users#index', as: 'users'
  post 'create_user', to: 'users#create', as: 'create_user'
  delete 'destroy_user/:id', to: 'users#destroy', as: 'destroy_user'
  post 'promote_user/:id', to: 'users#promote', as: 'promote_user'

  get 'reservations', to: 'reservations#index', as: 'user_root'
  devise_scope :user do
    root to: 'devise/sessions#new'
  end
  get '*path' => redirect('/')

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
