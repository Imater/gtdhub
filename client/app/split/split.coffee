'use strict'

angular.module('gtdhubApp').config ($stateProvider) ->
  $stateProvider.state 'split',
    url: '/split'
    templateUrl: 'app/split/split.html'
    controller: 'SplitCtrl'
