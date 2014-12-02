require 'ostruct'
class Beyonic::Webhook < OpenStruct

  include Beyonic::AbstractApi
  set_endpoint "https://staging.beyonic.com/api/webhooks"
  set_api_version "v1"
end