'use strict'

describe 'Controller: BlogCtrl', ->

  # load the controller's module
  beforeEach module 'gtdhubApp'
  beforeEach module 'socketMock'

  BlogCtrl = undefined
  scope = undefined
  timeout = undefined
  $httpBackend = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope, _$timeout_, _$httpBackend_) ->
    scope = $rootScope.$new()
    BlogCtrl = $controller('BlogCtrl',
      $scope: scope
    )
    $httpBackend = _$httpBackend_
    $httpBackend.expectGET('/api/articles').respond [
      {title: 'News1', date: new Date, html: 'text', active: true}
      {title: 'News2 not active', date: new Date, html: 'text', active: false}
      {title: 'News3 not active', date: new Date, html: 'text', active: false}
      {title: 'News4', date: new Date, html: 'text', active: true}
    ]
    $httpBackend.flush()
    timeout = _$timeout_
  )
  it 'should has isAdmin function', ->
    expect( scope.isAdmin ).toBeDefined()

  it 'should has isAdmin function', ->
    expect( scope.isAdmin ).toBeDefined()

  it 'startEdit function exists', ->
    expect( scope.startEdit ).toBeDefined()
    expect( scope.finishEdit ).toBeDefined()

  xit 'startEdit works', ()->
    article =
      edit: false
      editShow: false
    scope.startEdit( $('div'), article )
    timeout.flush()
    expect(article.edit).toBe true
    expect(article.editShow).toBe true

  xit 'startEdit works', ()->
    article =
      edit: true
      editShow: true
    scope.finishEdit( $('div'), article )
    timeout.flush()
    expect(article.edit).toBe false
    expect(article.editShow).toBe false

  it '$scope.filterBlogTreeMenu exists', ()->
    expect(scope.filterBlogTreeMenu.title).toBeDefined()