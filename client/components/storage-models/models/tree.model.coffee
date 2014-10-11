angular.module('gtdhubApp').factory 'TreeModel', (StoreCommonModel)->
  class TaskModel extends StoreCommonModel
    constructor: (tree)->
      @defaultModel =
        title: "New tree element"
      super 'tree', tree
