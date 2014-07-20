
angular = require "angular"
HomeCtrl = require "./controllers/home"
DocumentationCtrl = require "./controllers/documentation"

app = angular.module("sk", [])

app.controller("HomeCtrl", HomeCtrl)
app.controller("DocumentationCtrl", DocumentationCtrl)

console.log "Application initialized!"