  Rails.application.routes.draw do

devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" ,  registrations: "users/registrations"}


  get 'home/index'
  get 'home/about_us'
  root 'home#index'

  get 'notes/help'
  get 'notes/my_notes'
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):

    resources :feeds , :except => [:new , :create , :show , :edit , :update]
    get 'feeds/index'
    get 'feeds/feedback'
    get 'feeds/newsfeed'
    get 'feeds/search_people'
    get 'feeds/invite_people'
    get 'feeds/following'
    get 'feeds/followers'
    get 'feeds/search_results' 
    get 'feeds/hall_of_fame'
    resources :profiles do
        member do 
          put 'follow_user'
          put 'destroy_follow_user'
          get 'all'
          get 'created'
          get 'played'
          get 'quizzed'
          get 'upvoted'
          get 'commented'  
          get 'all_activity'
          get 'following'
          get 'followers'
          get 'notes'
        end  
      end
  
      resources :notes do
        get 'game_view'
        get 'display_widgets'
        resources :comments 
        member do
            put "like", to: "notes#upvote"
            put "unlike", to: "notes#unvote"
        end
      end


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
