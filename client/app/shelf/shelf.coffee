'use strict'

angular.module('gtdhubApp').config ($stateProvider) ->
  $stateProvider.state 'shelf',
    url: '/shelf'
    templateUrl: 'app/shelf/shelf.html'
    controller: 'ShelfCtrl'
