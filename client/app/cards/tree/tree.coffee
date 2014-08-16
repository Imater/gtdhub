'use strict'

angular.module('gtdhubApp').config ($stateProvider) ->
  $stateProvider.state 'cards.tree',
    url: '/tree/:id'
    views:
      'treeView':
        templateUrl : 'app/cards/tree/tree.html'
        controller: 'TreeCtrl'
      'stageView':
        templateUrl : 'app/cards/stage/stage.html'
        controller: 'StageCtrl'
      'historyView':
        templateUrl : 'app/cards/history/history.html'
        controller: 'HistoryCtrl'

    templateUrl: 'app/cards/tree/tree.html'
