Rails.application.routes.draw do

  patch 'hands/:id/hold', to: 'hands#hold'

  patch 'hands/:id/draw', to: 'hands#draw'
  
  post 'hands/deal', to: 'hands#deal', as: 'deal'
  
  get 'hands/:id', to: 'hands#show', as: 'hand'

end
