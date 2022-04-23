Rails.application.routes.draw do
  resources :titulos
  root 'csv#index'
  post 'titulos/importar', to: 'titulos#importar'
  get 'csv/titulo_registrado', to: 'csv#titulo_registrado'
  get 'csv/protestados', to: 'csv#protestados'
  get 'csv/titulos_da_base', to: 'csv#titulos_da_base'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
