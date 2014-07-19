
class HomeCtrl

  @$inject = ['$scope']

  constructor: (@scope) ->
    @scope.features = [
      'Jade'
      'Stylus'
      'CoffeeScript'
      'Browserify'
      'BrowserSync'
      'Angular'
      'Animate.css',
      'FontAwesome'
    ]

module.exports = HomeCtrl
