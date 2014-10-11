angular.module('gtdhubApp').factory 'SettingSyncModel', (StoreCommonModel, DateService)->
  class ConfigLocalModel extends StoreCommonModel
    constructor: (setting)->
      @defaultModel =
        settingCreated: new DateService().now()
      super 'SettingSync', setting
