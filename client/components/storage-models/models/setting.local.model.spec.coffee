'use strict'

describe 'Model SettingLocal', ->

  # load the controller's module
  beforeEach module('gtdhubApp')

  SettingLocalModel = undefined
  beforeEach inject (_SettingLocalModel_) ->
    SettingLocalModel = _SettingLocalModel_

  it 'exist task model', ->
    expect(SettingLocalModel).toBeDefined()
    settingLocalModel = new SettingLocalModel
      title: "SettingLocal"
      date: new Date();
    expect(settingLocalModel).toBeDefined()
    expect(settingLocalModel.get().title).toBe "SettingLocal"
