'use strict'

angular.module('gtdhubApp').controller 'ShelfCtrl', ($scope, treeSrv) ->
  $scope.shelfs = treeSrv.load()