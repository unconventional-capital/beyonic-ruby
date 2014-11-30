require 'ostruct'
class BeyonicApi::Webhook < OpenStruct

  extend BeyonicApi::AbstractApi
  set_endpoint "https://staging.beyonic.com/api/webhooks"
  set_api_verion "v1"
end