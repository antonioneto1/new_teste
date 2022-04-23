Rails.application.routes.draw do
  resources :titulos
  root 'consultas#index'
  post 'titulos/importar', to: 'titulos#importar'
  get 'consultas/titulo_registrado', to: 'consultas#titulo_registrado'
  get 'consultas/protestados', to: 'consultas#protestados'
  get 'consultas/titulos_da_base', to: 'consultas#titulos_da_base'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
