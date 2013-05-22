class Loader

  App: null

  constructor: (@App) ->

  getModules: () ->
    require 'config/modules'

  load: (condition, loadInApp = true) ->
    modules = @getModules()
    for k, v of modules
      if String(v).match condition
        if loadInApp
          filename = v.split('/').pop()
          className = Ember.String.classify filename
          @App[className] = require v
        else
          require v

module.exports = Loader
