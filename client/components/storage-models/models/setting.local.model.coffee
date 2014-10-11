angular.module('gtdhubApp').factory 'SettingLocalModel', (StoreCommonModel)->
  class ConfigLocalModel extends StoreCommonModel
    constructor: (setting)->
      @defaultModel = {}
      super 'SettingLocal', setting
