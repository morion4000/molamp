Molamp.Views.Albums ||= {}

class Molamp.Views.Albums.AlbumsView extends Backbone.View
  el: '#top-albums table tbody'

  initialize: ->    
    @.model.bind 'add', @.addOne, @
    
  addOne: (album) =>    
    view = new Molamp.Views.Albums.AlbumView model: album
            
    $(@.el).append view.render().$el
        
  addAll: ->
    $(@.el).html ''
    
    @.model.each @.addOne      
  
  render: ->    
    @.addAll()
      
    @