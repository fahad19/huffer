###
config/routes
###
App.Router.map ->
  @route 'index', path: '/'

  @resource 'pages', ->
    @route 'index', path: '/'
    @route 'about'
