'use strict'

describe 'Service: Auth', ->
  # load the service's module
  beforeEach module('gtdhubApp')

  # instantiate service
  Auth = undefined
  $httpBackend = undefined
  beforeEach inject((_Auth_, _$httpBackend_) ->
    Auth = _Auth_
    $httpBackend = _$httpBackend_
    $httpBackend.expectPOST('/auth/local').respond true
    $httpBackend.expectGET('/api/users/me').respond true
  )
  it 'should do something', ->
    expect(!!Auth).toBe true

  it 'login function exists', () ->
    user = {
      email: 'admin@admin.com'
      password: 'admin'
    }
    Auth.login(user).then (data)->
      expect(data).toBe true
    $httpBackend.flush()

  it 'login function exists', () ->
    user = {
      email: 'adminadmin.com'
      password: 'admin'
    }
    Auth.login(user).then (data)->
      expect(data).toBe true
    $httpBackend.flush()
