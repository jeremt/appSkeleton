
angular = require "angular"
HomeCtrl = require './controllers/home'

app = angular.module('sk', [])

app.controller('HomeCtrl', HomeCtrl)
