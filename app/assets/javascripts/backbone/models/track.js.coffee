class Molamp.Models.Track extends Backbone.Model
  defaults:
    uid: 0
    mbid: null
    artist: null
    title: null
    image: null
    listeners: 0
    playcount: 0
    url: null
    similar: no
    isSelected: no
 
class Molamp.Collections.Tracks extends Backbone.Collection
  model: Molamp.Models.Track
  
  initialize: ->
    @on 'change:isSelected', @onSelectedChanged, @
  
  onSelectedChanged: (model) ->
    @.each (model) ->
      if model.get('isSelected') is true and not model.hasChanged('isSelected')  
          model.set
            isSelected: no