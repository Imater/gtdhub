'use strict'
angular.module('gtdhubApp').controller 'TreeCtrl', ($scope, treeSrv, $stateParams) ->
  $scope.trees = treeSrv.get()
  $scope.$stateParams = $stateParams