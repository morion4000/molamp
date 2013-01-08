Molamp.Views.Tracks ||= {}

class Molamp.Views.Tracks.TracksView extends Backbone.View
  el: '#top-tracks table tbody'

  initialize: ->    
    @.model.bind 'add', @.addOne, @
    
  addOne: (track) =>    
    view = new Molamp.Views.Tracks.TrackView model: track
            
    $(@.el).append view.render().$el
        
  addAll: ->
    $(@.el).html ''
    
    @.model.each @.addOne      
  
  render: ->    
    @.addAll()
      
    @