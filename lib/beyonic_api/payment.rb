require 'ostruct'
class BeyonicApi::Payment < OpenStruct

  extend BeyonicApi::AbstractApi
  set_endpoint "https://staging.beyonic.com/api/payments"
  set_api_verion "v1"
end