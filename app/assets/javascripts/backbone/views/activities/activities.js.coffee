Molamp.Views.Activities ||= {}

class Molamp.Views.Activities.ActivitiesView extends Backbone.View
  el: '.social_activity table tbody'

  initialize: ->
    _.bindAll @
    
    @model.bind 'add', @addOne, @
    
  addOne: (activity) =>    
    view = new Molamp.Views.Activities.ActivityView model: activity
            
    $(@el).append view.render().$el
        
  addAll: ->
    $(@el).html ''
    
    @model.each @.addOne      
  
  render: ->
    @addAll()
      
    @