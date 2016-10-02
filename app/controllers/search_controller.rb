  class SearchController < ApplicationController
  # GET /search
  # GET /search.json
  def index
    # TODO: Need to redirect if the params are not set
    # BUG: If the artist name contains special characters, the application crashes
    @query = params[:q]
    @where = params[:w]

    begin
      @search = LastfmSearch.new(@query, @lastfm)
    rescue
      @search = nil
    end

    if @search and @search.respond_to?(:artistmatches) and @search.artistmatches.size > 0
      featured = @search.artistmatches[0]

      if @where == 'home'
        redirect_to '/artists/' + featured.name.gsub(' ', '+')
      else
         begin
           @featured = LastfmArtist.new(featured.name, @lastfm, false)
         rescue
           @featured = nil
         end
      end
    end
  end
end
