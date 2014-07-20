
module.exports = class

  @$inject = ['$scope']

  constructor: (@scope) ->
    @scope.links = [
      {name: 'Getting started', url: '/documentation/tutorials/gettingstarted.html'}
      {name: 'API', url: '/documentation/api/index.html'}
    ]
