#= require caroufredsel-6.1.0/jquery.caroufredsel-6.1.0.js

class Molamp.Home
  constructor: ->
    $('#main_search').typeahead
      source: (query, process) ->
        lastfm = new Molamp.LastfmWrapper
        
        $('.ajax-spinner').spin Molamp.Defaults::SPIN_OPTIONS
        
        lastfm.artist.search
          artist: query
          limit: 10
        , 
          success: (data) ->
            $('.ajax-spinner').spin off
            
            results = data.results.artistmatches.artist
             
            if typeof results is 'object'
              data = []
              
              for result in results
                data.push result['name']
              
              process data

      updater: (item) ->
        _gaq.push [
          '_trackEvent'
          'Hero'
          'Search'
          item
        ]
        
        location.href = '/artists/' + Alike.url_to_lastfm item
        
        item