###
usage: <textarea ng-model="content" redactor></textarea>

additional options:
redactor: hash (pass in a redactor options hash)
###

angular.module("angular-redactor", []).directive "redactor", [
  "$timeout", "$rootScope"
  ($timeout, $rootScope) ->
    return (
      restrict: "A"
      require: "ngModel"
      link: (scope, element, attrs, ngModel) ->
        updateModel = updateModel = (value) ->
          scope.$apply ->
            ngModel.$setViewValue value

        resizecontent = _.debounce ()->
          $(element).parents('.content').scroll();
        , 100

        $(window).resize ()->
          resizecontent();

        options = {
          changeCallback: _.debounce (value)->
            updateModel(value);
          , 100
          imageUpload: '/api/v1/uploadImage/?id='
          clipboardUploadUrl: '/api/v1/uploadImage/?id='
        }
        additionalOptions = (if attrs.redactor then scope.$eval(attrs.redactor) else {})
        editor = undefined
        $_element = angular.element(element)
        angular.extend options, additionalOptions

        # put in timeout to avoid $digest collision.  call render() to
        # set the initial value.
        $timeout ->
          editor = $_element.redactor(options)
          ngModel.$render()
        , 10

        ngModel.$render = ->
          if angular.isDefined(editor)
            #$timeout ->
            $_element.redactor "set", ngModel.$viewValue or "", false

        scope.$on '$destroy', ()->
          console.info 'destroy'
          $_element.redactor 'destroy'

    )
]
