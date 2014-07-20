
# It's an angular controller which handle all the behaviour related to the
# home page of the website.
#
class HomeCtrl

  @$inject = ['$scope']

  # Instanciate the controller and initialize all the feature into an array
  # which will be displayed in a list.
  #
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