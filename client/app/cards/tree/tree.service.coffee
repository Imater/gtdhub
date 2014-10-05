'use strict'

angular.module('gtdhubApp').service 'treeSrv', (Hierarhy, Id, Stage, Task) ->
  # AngularJS will instantiate a singleton by calling 'new' on this function

  colors = [
    {background: "#90dff8", background_light: "#C2F1FF"}
  ,
    {background: "#f8c82d", background_light: "#f8dca3"}
  ,
    {background: "#fbcf61", background_light: "#fbdab9"}
  ,
    {background: "#ff6f6f", background_light: "#ffbec4"}
  ,
    {background: "#e3a712", background_light: "#e3cb9c"}
  ]
  c = [
    {background: "#e5ba5a", background_light: "#f8c82d"}
  ,
    {background: "#d1404a", background_light: "#f8c82d"}
  ,
    {background: "#0dccc0", background_light: "#f8c82d"}
  ,
    {background: "#a8d164", background_light: "#f8c82d"}
  ,
    {background: "#3498db", background_light: "#f8c82d"}
  ,
    {background: "#0ead9a", background_light: "#f8c82d"}
  ,
    {background: "#27ae60", background_light: "#f8c82d"}
  ,
    {background: "#2989b9", background_light: "#f8c82d"}
  ,
    {background: "#d49e99", background_light: "#f8c82d"}
  ,
    {background: "#b23f73", background_light: "#f8c82d"}
  ,
    {background: "#48647c", background_light: "#f8c82d"}
  ,
    {background: "#74525f", background_light: "#f8c82d"}
  ,
    {background: "#832d51", background_light: "#f8c82d"}
  ,
    {background: "#e84b3a", background_light: "#f8c82d"}
  ,
    {background: "#fe7c60", background_light: "#f8c82d"}
  ,
    {background: "#ecf0f1", background_light: "#f8c82d"}
  ,
    {background: "#c0392b", background_light: "#f8c82d"}
  ,
    {background: "#bdc3c7", background_light: "#f8c82d"}

  ]

  lastIndex = 0;
  randomColor = ->
    #randomIndex = Math.round(Math.random()*(colors.length-1))
    answer = colors[lastIndex]
    if lastIndex < colors.length-1
      lastIndex++
    else
      lastIndex = 0
    answer

  class Tree extends Hierarhy
    constructor: (title) ->
      super
      @title = title || 'Новый проект'
      randomColorItem = randomColor()
      @background = randomColorItem.background
      @background_light = randomColorItem.background_light
      @id = Id.get()
    addStage: (stage)->
      @stage = [] if !@stage
      @stage.push stage
      stage



  main = undefined
  treeSrv =
    _Tree: Tree

    get: (id)->
      if !main
        main = @load()
      if !id
        return main
      else
        return main.getFind [], (el)->
          el if el.id == parseInt(id)

      main
    load: ()->
      main = new Tree '1. Working'
      main.open = true
      main2 = main.addChild new Tree '1.1 NetEagles'
      main2.open = true
      main3 = main2.addChild new Tree '1.2.1 Web-projects'
      miass = main3.addChild new Tree '1.2.1.1 Miass'
      main8 = main2.addChild new Tree '1.2.2 Soft-projects'
      main9 = main8.addChild new Tree '1.2.2.1 Go-soft'
      main9 = main8.addChild new Tree '1.2.2.2 Angular-soft'
      main9 = main9.addChild new Tree 'Inside Angular'
      main9.addChild new Tree 'Inside Angular1'

      main2.addChild new Tree '1.2.1 Inside Web-projects1'
      main2.addChild new Tree '1.2.1 Inside Web-projects2'
      main2.addChild new Tree '1.2.1 Inside Web-projects3'
      main2.addChild new Tree '1.2.1 Inside Web-projects4'
      main2.addChild new Tree '1.2.1 Inside Web-projects5'
      main.addChild new Tree 'Main 1'
      main.addChild new Tree 'Main 2'
      main.addChild new Tree 'Main 3'
      main.addChild new Tree 'Main 4'
      main.addChild new Tree 'Main 5'


      s = main9.addChild new Tree 'Inside Angular2'
      s.addChild new Tree 'Inside Angular2 !!!'
      main9.addChild new Tree 'Inside Angular3'
      main9.addChild new Tree 'Inside Angular4'
      main9.addChild new Tree 'Inside Angular5'


      main9 = main8.addChild new Tree '1.2.2.3 Coffee-soft'
      main9 = main8.addChild new Tree '1.2.2.4 Git-soft'

      main4 = main.addChild new Tree '1.2 Home projects'
      main4.addChild new Tree '1.2.1 Health'
      s = main4.addChild new Tree '1.2.2 Run'
      s.addChild new Tree 'Inside Run1'
      s.addChild new Tree 'Inside Run2'
      s.addChild new Tree 'Inside Run3'
      s.addChild new Tree 'Inside Run4'
      s.addChild new Tree 'Inside Run5'
      s.addChild new Tree 'Inside Run6'
      s.addChild new Tree 'Inside Run7'
      s.addChild new Tree 'Inside Run8'
      main4.addChild new Tree '1.2.3 Food'


      stage1 = miass.addStage new Stage { title: 'Back log', treeId: miass.id }
      stage1.addTask new Task {title: 'Сделать Drag&Drop'}
      stage1.addTask new Task {title: 'Посмотреть фильм'}
      stage1.addTask new Task {title: 'Скачать новую операционку'}

      stage1 = miass.addStage new Stage { title: 'To-do', treeId: miass.id }
      stage1.addTask new Task {title: 'Сделать Drag&Drop'}
      stage1.addTask new Task {title: 'Посмотреть фильм'}

      stage1 = miass.addStage new Stage { title: 'Doing', treeId: miass.id }
      stage1.addTask new Task {title: 'Сделать Drag&Drop'}

      stage1 = miass.addStage new Stage { title: 'Done', treeId: miass.id }
      stage1.addTask new Task {title: 'Сделать Drag&Drop'}
      stage1.addTask new Task {title: 'Посмотреть фильм'}
      stage1.addTask new Task {title: 'Скачать новую операционку'}
      stage1.addTask new Task {title: 'Сделать Drag&Drop'}
      stage1.addTask new Task {title: 'Посмотреть фильм'}
      stage1.addTask new Task {title: 'Скачать новую операционку'}

      main3 = main4.addChild new Tree 'Trello'
      main3.addStage new Stage { title: 'To-do', treeId: miass.id }
      main3.addStage new Stage { title: 'Doing', treeId: miass.id }
      main3.addStage new Stage { title: 'Done', treeId: miass.id }


      main
  treeSrv
