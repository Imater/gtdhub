'use strict'

angular.module('gtdhubApp').config ($stateProvider) ->
  $stateProvider.state 'cards',
    url: '/cards'
    templateUrl: 'app/cards/cards.html'
    controller: 'CardsCtrl'
