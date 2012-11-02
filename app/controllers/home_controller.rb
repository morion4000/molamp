class HomeController < ApplicationController
  def index
    code = params[:code]
    
    if !code.to_s.blank?
      redirect_to '/account/new?code='+code
    end
  end
end
