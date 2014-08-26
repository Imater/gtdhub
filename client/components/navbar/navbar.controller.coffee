'use strict'

angular.module('gtdhubApp').controller 'NavbarCtrl', ($scope, $location, Auth) ->
  $scope.menu = [
    title: 'Home'
    link: '/'
  ,
    title: 'Cards'
    link: '/cards/tree/'
  ,
    title: 'Blog'
    link: '/blog'
  ,
    title: 'Slides'
    link: '/shelf'
  ,
    title: 'Split'
    link: '/split'
  ]
  $scope.Auth = {}
  $scope.isAdmin = Auth.isAdmin
  $scope.Auth.isAdmin = Auth.isAdmin
  $scope.isCollapsed = true
  $scope.isLoggedIn = Auth.isLoggedIn
  $scope.getCurrentUser = Auth.getCurrentUser

  $scope.logout = ->
    Auth.logout()
    $location.path '/login'

  $scope.isActive = (route) ->
    route is $location.path()