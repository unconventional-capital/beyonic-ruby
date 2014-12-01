require "beyonic/version"
require "beyonic/abstract_api"
require "beyonic/payment"
require "beyonic/webhook"

module Beyonic

  #Fixme!  remove me after getting new cert
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  def self.api_key=(key)
    @api_key = key
  end

  def self.api_key
    @api_key
  end
end
