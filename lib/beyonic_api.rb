require "beyonic_api/version"
require "beyonic_api/abstract_api"
require "beyonic_api/payment"
require "beyonic_api/webhook"

module BeyonicApi

  #Fixme!  remove me after getting new cert
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  def self.api_key=(key)
    @api_key = key
  end

  def self.api_key
    @api_key
  end
end
