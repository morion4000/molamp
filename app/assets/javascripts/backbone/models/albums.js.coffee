class Molamp.Models.Album extends Backbone.Model
  defaults:
    title: null
    image: null
    playcount: 0
    url: null
 
class Molamp.Collections.Albums extends Backbone.Collection
  model: Molamp.Models.Album