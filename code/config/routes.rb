Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :articles
  resources :product_images
  root 'home#index'
  get 'homelogin/login'
  get 'home/index'
  post 'home/index'
  post 'home/search'
  post 'home/follow'
  post 'home/unfollow'
  get 'home/search'
  get 'home/test_ajax'
  get 'home/userprofile'
  post 'home/upload_avatar'
  get 'home/upload_avatar'
  get 'home/geolocation'
  get 'home/myprofile'
  get 'home/review'
  post 'home/review_post'
  get 'home/test'
  get 'home/BurgerProfile/:id'=>'home#BurgerProfile'
  get 'home/login'
  get 'home/locations'
  post 'home/login'
  post 'home/addSession'
  get 'home/addSession'
  post 'home/addlike'
  post'home/getchangeproduct'
  post'home/actionSendMail'
  post '/home/uploadImgaes'
  post '/home/AddComemnt'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  # resources :users


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
