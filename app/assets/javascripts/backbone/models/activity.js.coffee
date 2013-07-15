class Molamp.Models.Activity extends Backbone.Model
  defaults:
    id: null
    image: null
    artist: null
    track: null
    action: null
    artist_url: null
    track_url: null
    remove_link: null
    remove_text: null
 
class Molamp.Collections.Activities extends Backbone.Collection
  model: Molamp.Models.Activity