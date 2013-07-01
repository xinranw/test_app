TestApp::Application.routes.draw do

  root :to => 'query#index'

  get "query/fetch"
  get "query/test"

  match "query_fetch_path" => "query#fetch"
  match "query_display1_path" => "query#display1"
  match "query_display2_path" => "query#display2"
  match "query_display3_path" => "query#display3"
  match "query_display4_path" => "query#display4"
  match "query_display5_path" => "query#display5"
  match "query_display6_path" => "query#display6"
  match "query_display7_path" => "query#display7"
  match "query_display8_path" => "query#display8"
  match "query_display9_path" => "query#display9"
  match "query_display10_path" => "query#display10"

end
