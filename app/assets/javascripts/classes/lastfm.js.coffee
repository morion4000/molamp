class Molamp.LastfmWrapper
  apiKey: '930976e93a9a305ccd319242e2a90e58'
  apiSecret: 'fa79a2ce3ac9477157b158fd08bf06f4'
  
  constructor: ->
    # Create a cache object
    cache = new LastFMCache()

    # Create and return the LastFM object
    return new LastFM
      apiKey: @apiKey
      apiSecret: @apiSecret      
      cache: cache
# 
  # similarTracks: (mbid) ->
    # @LF.track.getSimilar({
      # mbid: mbid
      # limit: 5
    # }, {
      # success: (data) ->
        # if typeof data.similartracks.track is 'object'
          # Alike.appendSimilarTracks mbid, data  
        # else
          # $.gritter.add
            # title: 'Similar tracks...'
            # text: 'We couldn\'t find any similar tracks'
#             
      # error: (code, message) ->
        # $.gritter.add
          # title: 'Similar tracks...'
          # text: 'We couldn\'t find any similar tracks'
    # })
#   
  # scrobble: (artist, track, image) ->
    # $.ajax
      # url: '/ajax/scrobble'
      # success: (data) ->       
        # Activity.add
          # id: md5(new Date())
          # artist: artist
          # track: track
          # image: image
        # , Activity.SCROBBLE
#     
        # $.gritter.add
          # title: 'Track scrobbled...'
          # text: "<strong>#{artist} - #{track}</strong> was scrobbled on Last.fm"
      # data:
        # artist: artist
        # track: track
      # dataType: 'json'
# 
  # activity: (artist, track, image) ->
    # $.ajax
      # url: '/ajax/activity'
      # timeout: 20*1000
      # success: (data) ->       
        # Activity.add
          # id: data.id
          # artist: artist
          # track: track
          # image: image
        # , Activity.TIMELINE
#     
        # $.gritter.add
          # title: 'Video posted on timeline...'
          # text: "<strong>#{artist} - #{track}</strong> was posted on your Facebook timeline"
      # data:
        # artist: artist
        # track: track
      # dataType: 'json'
