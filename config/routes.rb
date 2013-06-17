TestApp::Application.routes.draw do

  root :to => 'query#index'

  get "query/fetch"
  get "query/test"
  match "query_fetch_path" => "query#fetch"


end
