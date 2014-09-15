'use strict'
angular.module('gtdhubApp').controller 'CardsTreeCtrl', ($scope, treeSrv, $stateParams) ->
  $scope.$stateParams = $stateParams
  $scope.panels = [
    {
      height: 80
      rows: [
        cards: [
          { title: 'Дневник' }
          { title: 'Домашние дела' }
          { title: 'Рабочие дела' }
          { title: 'Записная книжка' }
          { title: 'Анекдоты' }
        ]
      ]
    }
  ,
    {
      height: 150
      rows: [
        cards: [
          { title: 'Январь' }
          { title: 'Февраль' }
          { title: 'Март' }
          { title: 'Апрель' }
          { title: 'Май' }
        ]
      ,
        cards: [
          { title: 'Июнь' }
          { title: 'Июль' }
        ]
      ]
    }
  ,
    {
      title: ''
      height: 250
      rows: [
        cards: [
          { title: '1 Марта' }
          { title: '2 Марта' }
          { title: '3 Марта' }
          { title: '4 Марта' }
          { title: '5 Марта' }
        ]
      ,
        cards: [
          { title: '6 Марта' }
          { title: '7 Марта' }
          { title: '8 Марта' }
          { title: '9 Марта' }
          { title: '10 Марта' }
        ]
      ,
        cards: [
          { title: '11 Марта' }
          { title: '12 Марта' }
          { title: '13 Марта' }
          { title: '14 Марта' }
          { title: '15 Марта' }
        ]
      ,
        cards: [
          { title: '16 Марта' }
          { title: '17 Марта' }
          { title: '18 Марта' }
          { title: '19 Марта' }
          { title: '20 Марта' }
        ]
      ,
        cards: [
          { title: '21 Марта' }
          { title: '22 Марта' }
          { title: '23 Марта' }
          { title: '24 Марта' }
          { title: '25 Марта' }
        ]
      ,
        cards: [
          { title: '26 Марта' }
          { title: '27 Марта' }
          { title: '28 Марта' }
          { title: '29 Марта' }
          { title: '30 Марта' }
        ]
      ]
    }

  ]
