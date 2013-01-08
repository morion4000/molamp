class Molamp.LastfmWrapper
  constructor: ->
    # Create a cache object
    cache = new LastFMCache()

    # TODO: Cache component is not working on IE

    # Create and return the LastFM object
    return new LastFM
      apiKey: Molamp.Defaults::LASTFM_OPTIONS.apiKey
      apiSecret: Molamp.Defaults::LASTFM_OPTIONS.apiSecret      
      cache: cache

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