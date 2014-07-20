
# This class handle all behaviours related to the documentations page. It
# generates the sidebar which contains documentation links and show/hide pages
# when user click on links on this sidebar.
#
class DocumentationCtrl

  @$inject = ['$scope', '$http']

  # Instanciate the documentation controller and initialize the documentation
  # links of the sidebar.
  #
  constructor: (@scope, @http) ->
    @scope.current = 0
    @scope.links = []
    @scope.error = null
    @http.get('/documentation/tutorials/config.json').success (response) =>
      if response.summary
        @scope.links = response.summary
      else
        @scope.error = "no summary field in configuration file"

  getUrl: (link) ->
    "/documentation/tutorials/#{link.id}.html"

  changePage: (index) ->
    @scope.current = index

module.exports = DocumentationCtrl