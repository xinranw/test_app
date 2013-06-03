TestApp::Application.routes.draw do
  get "query/index"

  root to: 'query#index'
end
