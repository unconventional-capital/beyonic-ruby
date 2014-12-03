module Beyonic

  require "rest-client"
  require "oj"

  #Fixme!  remove me after getting new cert
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  
  def self.api_key=(key)
    @api_key = key
  end

  def self.api_key
    @api_key
  end

  def self.api_version=(version)
    @apk_version = version
  end
  
  def self.api_version
     @apk_version
  end

  def self.endpoint_base
    "https://staging.beyonic.com/api/"
  end

end

require "beyonic/version"
require "beyonic/abstract_api"
require "beyonic/payment"
require "beyonic/webhook"
