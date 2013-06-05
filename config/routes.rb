TestApp::Application.routes.draw do
  get "query/index"
  get "query/fetch"

  root to: 'query#index'
end
