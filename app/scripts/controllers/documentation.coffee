
# @class DocumentationCtrl
#
# This class handle all behaviours related to the documentations page. It
# generates the sidebar which contains documentation links and show/hide pages
# when user click on links on this sidebar.
#
module.exports = class

  @$inject = ['$scope']

  # Instanciate the documentation controller and initialize the documentation
  # links of the sidebar.
  #
  constructor: (@scope) ->
    @scope.links = [
      {name: 'Getting started', url: '/documentation/tutorials/gettingstarted.html'}
      {name: 'API', url: '/documentation/api/index.html'}
    ]
