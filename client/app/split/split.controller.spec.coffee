'use strict'

describe 'Controller: SplitCtrl', ->

  # load the controller's module
  beforeEach module('gtdhubApp')
  SplitCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    SplitCtrl = $controller('SplitCtrl',
      $scope: scope
    )
  )
  it 'should ...', ->
    expect(1).toEqual 1
