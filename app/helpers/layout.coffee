###
helpers/layout
###
Ember.Handlebars.registerBoundHelper 'pageHeader', (title, options) ->
  out  = '<div class="page-header">'
  out += '<h1>' + title + '</h1>'
  out += '</div>'
  new Handlebars.SafeString out
