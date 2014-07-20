
# This class handle all behaviours related to the documentations page. It
# generates the sidebar which contains documentation links and show/hide pages
# when user click on links on this sidebar.
#
class DocumentationCtrl

  @$inject = ['$scope']

  # Instanciate the documentation controller and initialize the documentation
  # links of the sidebar.
  #
  constructor: (@scope) ->
    @scope.current = 0
    @scope.links = [
      {id: 'introduction', name: 'Introduction'}
      {id: 'gettingstarted', name: 'Getting started'}
    ]

  getUrl: (link) ->
    "/documentation/tutorials/#{link.id}.html"

  changePage: (index) ->
    @scope.current = index

module.exports = DocumentationCtrl