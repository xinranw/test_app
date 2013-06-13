TestApp::Application.routes.draw do

  root :to => 'query#index'

  get "query/fetch"
  match "query_fetch_path" => "query#fetch"


end
