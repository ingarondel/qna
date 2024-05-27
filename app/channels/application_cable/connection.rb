module ApplicationCable
  class Connection < ActionCable::Connection::Base
    def  echo(data)
      transmit data
    end
  end
end
