Molamp.Views.Albums ||= {}

class Molamp.Views.Albums.AlbumView extends Backbone.View
  template: JST['backbone/templates/album-template']
  tagName: 'tr'

  initialize: ->
    #console.log 'init album view'

  render: ->
    @.$el.html(@template album: @model.toJSON())
    
    @
    