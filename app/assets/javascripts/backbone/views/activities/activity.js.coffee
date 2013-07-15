Molamp.Views.Activities ||= {}

class Molamp.Views.Activities.ActivityView extends Backbone.View
  template: JST['backbone/templates/activity-template']
  tagName: 'tr'

  initialize: ->
    #console.log 'init album view'

  render: ->
    @.$el.html(@template activity: @model.toJSON())
    
    @
    