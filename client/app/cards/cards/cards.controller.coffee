'use strict'
angular.module('gtdhubApp').filter "pmkr.partition", [
  "pmkr.filterStabilize"
  (stabilize) ->
    filter = stabilize((arr, size) ->
      newArr = []
      i = 0

      while i < arr.length
        newArr.push arr.slice(i, i + size)
        i += size
      newArr
    )
    return filter
]

angular.module('gtdhubApp').controller 'CardsTreeCtrl', ($scope, treeSrv, $stateParams) ->
  $scope.$stateParams = $stateParams
  $scope.trees = treeSrv.get()

  $scope.toggleOpenChilds = (row, tree)->
    if (row.showChilds && row.showChilds.id == tree.id)
      row.showChilds = undefined
    else #if (tree.childs && tree.childs.length>0)
      row.showChilds = tree
