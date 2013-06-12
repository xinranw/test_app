TestApp::Application.routes.draw do

  root to: 'query#index'

  get "query/index"
  match "query_index_path" => "query#index"


end
