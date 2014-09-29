'use strict'

angular.module('gtdhubApp').config ($stateProvider) ->
  $stateProvider.state 'cup',
    url: '/cup'
    templateUrl: 'app/cup/cup.html'
    controller: 'CupCtrl'
