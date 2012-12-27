$ ->
  # Enable Bootstrap tooltip
  $('[rel=tooltip]').tooltip()
  
  # Search box on the menu
  $('#generic_search').typeahead
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
           
          if typeof results == 'object'
            data = []
            
            for result in results
              data.push result['name']
            
            process data
  
    updater: (item) ->
      _gaq.push [
        '_trackEvent'
        'Menu'
        'Search'
        item
      ]
      
      utils = new Molamp.Utils
      
      location.href = '/artists/' + utils.url_to_lastfm item
      
      item