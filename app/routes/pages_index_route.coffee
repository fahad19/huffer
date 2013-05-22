###
routes/pages_index_route
###
PagesIndexRoute = Ember.Route.extend

  setupController: (controller) ->
    controller.set 'title', 'Pages'

module.exports = PagesIndexRoute