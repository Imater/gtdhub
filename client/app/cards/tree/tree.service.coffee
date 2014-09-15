'use strict'

angular.module('gtdhubApp').service 'treeSrv', (Hierarhy, Id, Stage, Task) ->
  # AngularJS will instantiate a singleton by calling 'new' on this function


  class Tree extends Hierarhy
    constructor: (title) ->
      super
      @title = title || 'Новый проект'
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
      main2 = main.addChild new Tree 'NetEagles'
      main3 = main2.addChild new Tree 'Web-projects'
      miass = main3.addChild new Tree 'Miass'
      main8 = main2.addChild new Tree 'Soft-projects'
      main9 = main8.addChild new Tree 'Go-soft'
      main9 = main8.addChild new Tree 'Angular-soft'
      main9 = main8.addChild new Tree 'Coffee-soft'
      main9 = main8.addChild new Tree 'Git-soft'

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

      main3 = main3.addChild new Tree 'Trello'
      main3.addStage new Stage { title: 'To-do', treeId: miass.id }
      main3.addStage new Stage { title: 'Doing', treeId: miass.id }
      main3.addStage new Stage { title: 'Done', treeId: miass.id }

      main4 = main.addChild new Tree '1.2 Home projects'
      main4.addChild new Tree '1.2.1 Health'
      main4.addChild new Tree '1.2.2 Run'
      main4.addChild new Tree '1.2.3 Food'

      main
  treeSrv
