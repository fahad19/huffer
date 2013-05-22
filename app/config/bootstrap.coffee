###
config/bootstrap
###

# create App
window.App = Ember.Application.create()

# get routings
require 'config/routes'

# load objects in window.App
Loader = require 'lib/loader'
loader = new Loader window.App
loader.load /^controllers\//
loader.load /^helpers\//, false
loader.load /^models\//
loader.load /^routes\//
loader.load /^views\//
