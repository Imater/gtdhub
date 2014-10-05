'use strict'

angular.module("pmkr.memoize", []).factory "pmkr.memoize", [->
  service = ->
    memoizeFactory.apply this, arguments
  memoizeFactory = (fn) ->
    memoized = ->
      args = [].slice.call(arguments)
      key = JSON.stringify(args)
      return cache[key]  if cache.hasOwnProperty(key)
      cache[key] = fn.apply(this, arguments)
      cache[key]
    cache = {}
    memoized
  service
]

angular.module("pmkr.filterStabilize", ["pmkr.memoize"]).factory "pmkr.filterStabilize", [
  "pmkr.memoize"
  (memoize) ->
    service = (fn) ->
      filter = ->
        args = [].slice.call(arguments)

        # always pass a copy of the args so that the original input can't be modified
        args = angular.copy(args)

        # return the `fn` return value or input reference (makes `fn` return optional)
        filtered = fn.apply(this, args) or args[0]
        filtered
      memoized = memoize(filter)
      memoized
    return service
]

angular.module('gtdhubApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'pmkr.filterStabilize'
  'btford.socket-io',
  'ui.router',
  'ui.bootstrap'
  'angular-redactor'
]).config ($stateProvider, $urlRouterProvider, $locationProvider, $httpProvider) ->
  $urlRouterProvider
  .otherwise '/cards/tree/'

  $locationProvider.html5Mode true
  $httpProvider.interceptors.push 'authInterceptor'

.factory 'authInterceptor', ($rootScope, $q, $cookieStore, $location) ->
  # Add authorization token to headers
  request: (config) ->
    config.headers = config.headers or {}
    config.headers.Authorization = 'Bearer ' + $cookieStore.get 'token' if $cookieStore.get 'token'
    config

  # Intercept 401s and redirect you to login
  responseError: (response) ->
    if response.status is 401
      $location.path '/login'
      # remove any stale tokens
      $cookieStore.remove 'token'

    $q.reject response

.run ($rootScope, $location, Auth) ->
  # Redirect to login if route requires auth and you're not logged in
  $rootScope.$on '$stateChangeStart', (event, next) ->
    Auth.isLoggedInAsync (loggedIn) ->
      $location.path "/login" if next.authenticate and not loggedIn
