
# It's an angular controller which handle all the behaviour related to the
# home page of the website.
#
module.exports = class

  # Declaring a `$inject` static method into a controller say to angular to
  # inject the given dependencies into the constructor of the controller.
  #
  @$inject = ['$scope']

  # Instanciate the controller and initialize the feature array.
  #
  # @param {String} scope the angular scope to store binded data
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
