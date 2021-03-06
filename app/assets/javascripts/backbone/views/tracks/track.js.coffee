Molamp.Views.Tracks ||= {}

class Molamp.Views.Tracks.TrackView extends Backbone.View
  template: JST['backbone/templates/track-template']
  tagName: 'tr'
  events:
    'click': 'play'
    #'click .similar_track': 'similar'
    #'mouseenter': 'highlight_on'
    #'mouseleave': 'highlight_off'

  initialize: ->
    _.bindAll @
    
    @model.on 'change:isSelected', @onSelectedChange

  render: ->
    @.$el.html(@template track: @model.toJSON())
    
    @
    
  play: ->
    Dispatcher.trigger 'player:play', @model
  
  onSelectedChange: -> 
    if @model.get('isSelected') is on
      @.$el.addClass 'active_track'
    else
      @.$el.removeClass 'active_track'
       
  # similar: (e) ->
    # # Do not play the track
    # e.stopPropagation()
#     
    # button = $(@.el).find('a.similar_track').children('i')
#         
    # if button.attr('class') is 'icon-plus-sign'
      # Molamp.similarTracks @
# 
      # button.removeClass('icon-plus-sign')
      # button.addClass('icon-minus-sign') 
    # else
      # Molamp.removeSimilarTracks @
#   
      # button.addClass('icon-plus-sign')
      # button.removeClass('icon-minus-sign')
  
  # highlight_on: ->
    # $(@.el).find('a.similar_track').removeClass 'disabled'
# 
  # highlight_off: ->
    # $(@.el).find('a.similar_track').addClass 'disabled'
