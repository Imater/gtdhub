'use strict'

angular.module('gtdhubApp')
.controller 'BlogCtrl', ($scope, Auth, $timeout, $http, socket) ->

  $scope.isAdmin = Auth.isAdmin

  $scope.startEdit = (el, article) ->
    article.edit = true
    articleHtml = $(el.target).parents('.article-wrap:first')
    $timeout ()->
      article.editShow = true
    , 50
    $timeout ()->
      article.editShow = true
      articleHtml.find('.redactor_toolbar').slideDown 300
    , 200
    return

  $scope.finishEdit = (el, article) ->
    articleHtml = $(el.target).parents('.article-wrap:first')
    articleHtml.find('.redactor_toolbar').slideUp 150
    $http.put("/api/articles/#{article._id}", article).success (resArticle) ->
      $timeout ()->
        article.editShow = false
        article.edit = false
      , 160

    return

  $scope.addArticle = () ->
    $http.post("/api/articles", {
      title: 'new article'
      html: 'text'
      date: new Date()
      active: false
    }).success (resArticle) ->
      $scope.refreshArticles()


  $scope.deleteArticle = (el, article) ->
    $http.delete("/api/articles/#{article._id}").success (resArticle) ->
      $scope.refreshArticles()

  $scope.filterBlogTreeMenu = {
    title: "All blog"
    cnt: 23
    childs: [
      title: 'CoffeeScript'
      cnt: 5
    ,
      title: 'Angular'
      cnt: 6
      childs: [
        title: 'Directives'
        cnt: 4
      ,
        title: 'Filters'
        cnt: 1
      ,
        title: 'Services'
        cnt: 2
      ,
        title: 'UI Router'
        cnt: 3
      ]
    ,
      title: 'HTML5'
      cnt: 12
    ]
  }

  $scope.refreshArticles = ->
    $http.get('/api/articles').success (articles) ->
      $scope.articles = articles
      socket.syncUpdates 'article', $scope.articles

  $scope.refreshArticles()
