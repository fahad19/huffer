###
routes/pages_about_route
###
PagesAboutRoute = Ember.Route.extend
  
  setupController: (controller) ->
    controller.set 'title', 'About'

module.exports = PagesAboutRoute