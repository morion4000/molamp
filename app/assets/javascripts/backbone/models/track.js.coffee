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
 
class Molamp.Collections.Tracks extends Backbone.Collection
  model: Molamp.Models.Track