angular.module('gtdhubApp').factory 'TaskModel', (StoreCommonModel)->
  class TaskModel extends StoreCommonModel
    constructor: (tree)->
      @defaultModel =
        title: "New task"
      super 'task', tree
