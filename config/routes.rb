Rails.application.routes.draw do
  namespace :api do
    resources :group_events, :defaults => { :format => 'json' } do
      member do
        post :publish
        post :unpublish
      end

      collection do
        get :published
        get :drafts
      end
    end
  end
end
