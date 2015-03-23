Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :articles
  resources :product_images

  root 'home#index'
  get 'homelogin/login'

  get '/index'=>'home#index',as: 'index'
  post '/index'=>'home#index',as: 'indexs'

  post 'home/search'
  post '/search'=>'home#search',as: 'postsearch'
  post 'home/follow'
  post 'home/unfollow'

  get 'home/search'
  get '/search'=>'home#search',as: 'getsearch'

  get 'home/test_ajax'

  get '/userprofile/:id'=> 'home#userprofile'

  get 'home/news'
  post 'home/user_meta'
  post 'home/update_profile'
  post 'home/upload_avatar'
  get 'home/upload_avatar'
  get 'home/geolocation'
  get 'home/myprofile'

  get '/review'=> 'home#review'
  get 'reviewuser'=>'home#reviewuser'
  post 'home/review_post'
  get 'home/test'
  post 'home/user_meta_country_city'
  post 'home/update_user_meta_country_city'
  get 'BurgerProfile/:id'=>'home#BurgerProfile'

  get '/login'=>'home#login',as: 'login'
  get 'home/locations'
  post '/login'=>'home#login',as: 'logins'
  post 'home/addSession'
  get 'home/addSession'
  post 'home/addlike'
  post'home/getchangeproduct'
  post'home/actionSendMail'
  post '/home/uploadImgaes'
  post '/home/AddComemnt'
  post 'home/addlocation'
  post 'home/CheckEmail'
  post 'home/getUserFllow'
  post '/home/getcityByIDCountry'
  post '/home/addlikeComemnt'
  post '/admin/restaurants/change_country'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", confirmations: 'confirmations' }
  # devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
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
