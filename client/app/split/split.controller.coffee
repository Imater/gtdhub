'use strict'

angular.module('gtdhubApp').controller 'SplitCtrl', ($scope) ->

  $scope.message = 'Hello'

  row1 =
    height: 100
    cols : [
      {
        width: 0
        hide: true
        color: '#C6C5C3'
        include: 'app/cards/tree/tree.html'
        controller: 'TreeCtrl'
      }
    ,
      {
        width: 80
        color: '#4D7AB5'
        include: 'app/cards/cards/cards.html'

      }
    ,
      {
        width: 0
        hide: true
        color: '#EEE'
      }
  ]

  $scope.windows =
    rows: [
      row1
    ]

  $(".resize-handle").on "mousedown", (e)->
    $(".layout-wrap").addClass("not-selectable")
    windowWidth = $(".layout-wrap").width()
    left = $(this).prev('.layout-col')
    right = $(this).next('.layout-col')
    oldLeft = left.width()/windowWidth*100;
    oldRight = right.width()/windowWidth*100;
    oldX = e.clientX
    onMouseMove = _.throttle (e) ->
      left.width( oldLeft - ( (oldX - e.clientX) )/windowWidth*100 + '%' )
      right.width( oldRight + ( (oldX - e.clientX) )/windowWidth*100 + '%' )
    , 50
    onMouseUp = ->
      $(window.document).off("mousemove", onMouseMove).off("mouseup", onMouseUp)
      offMouseEvents()

    offMouseEvents = ->
      $(".layout-wrap").removeClass("not-selectable")
      $(window.document).off("mousemove", onMouseMove).off("mouseup", onMouseUp)

    $(window.document).on "mousemove", onMouseMove
    .on "mouseup", onMouseUp
    $(".layout-wrap").on "mouseleave", ()->
      offMouseEvents()

  $(".resize-handle-h").on "mousedown", (e)->
    $(".layout-wrap").addClass("not-selectable")
    windowHeight = $(".layout-wrap").height()
    top = $(this).prev('.layout-inside-row')
    bottom = $(this).next('.layout-inside-row')
    oldTop = top.height()/windowHeight*100;
    oldBottom = bottom.height()/windowHeight*100;
    oldY = e.clientY
    onMouseMove = _.throttle (e) ->
      top.height( oldTop - ( (oldY - e.clientY) )/windowHeight*100 + '%' )
      bottom.height( oldBottom + ( (oldY - e.clientY) )/windowHeight*100 + '%' )
    , 50
    offMouseEvents = ->
      $(window.document).off("mousemove", onMouseMove).off("mouseup", onMouseUp)
      $(".layout-wrap").removeClass("not-selectable")
    onMouseUp = ->
      offMouseEvents()
    $(window.document).on "mousemove", onMouseMove
    .on "mouseup", onMouseUp
    $(".layout-wrap").on "mouseleave", ()->
      offMouseEvents()
