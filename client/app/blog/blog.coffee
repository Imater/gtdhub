'use strict'

angular.module('gtdhubApp').config ($stateProvider) ->
  $stateProvider.state 'blog',
    url: '/blog'
    templateUrl: 'app/blog/blog.html'
    controller: 'BlogCtrl'
