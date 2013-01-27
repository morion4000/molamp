class Molamp.LastfmWrapper
  constructor: ->
    # Create a cache object
    #cache = new LastFMCache()

    # Create and return the LastFM object
    return new LastFM
      apiKey: Molamp.Defaults::LASTFM_OPTIONS.apiKey
      apiSecret: Molamp.Defaults::LASTFM_OPTIONS.apiSecret      
      #cache: cache