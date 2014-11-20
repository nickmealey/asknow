Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  resources :landing
  
  # Community
  get   'community'       => 'community#index'
  post  'community/pick'  => 'community#pick', as: 'pick_community'
  
  # Feed
  get   'feed'           => 'feed#account', as: 'feed'
  get   'feed/:tag'      => 'feed#show', as: 'feed_show'
  get   'recent'         => 'feed#recent', as: 'recent'
  post  'feed/add'       => 'feed#add', as: 'feed_add'
  get   'trending'       => 'feed#trending', as: 'trending'
  
  # Account
  get   'account'           => 'account#panel', as: 'account_panel'
  
  # Member
  get   'member/new'       => 'member#new', as: 'member_new'
  post  'member/new'       => 'member#create', as: 'member_create'
  get   'member/success'   => 'member#success'
  
  # Session
  get   'session/login'    => 'session#login', as: 'session_login'
  post  'session/login'    => 'session#authenticate'
  post   'session/logout'   => 'session#logout', as: 'session_logout'
  
  # Question
  get   'question'      => 'question#index'
  post  'question'      => 'question#ask', as: 'question_ask'
  get   'question/:id'  => 'question#show', as: 'question_show'
  
  # Answer
  post  'question/:id/answer'   => 'answer#new', as: 'answer_new'
  
  # Vote
  post  'answer/:id/vote'   => 'vote#cast', as: 'vote_cast'

  root  'landing#index'
end
