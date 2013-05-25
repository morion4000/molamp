class Stats

  def send(metric, value)
    require 'socket'

    apikey = ENV['HOSTEDGRAPHITE_APIKEY']
    sock   = UDPSocket.new
    sock.send "#{apikey}.#{metric} #{value}\n", 0, "carbon.hostedgraphite.com", 2003
  end

end
