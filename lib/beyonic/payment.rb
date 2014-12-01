require 'ostruct'
class Beyonic::Payment < OpenStruct

  extend Beyonic::AbstractApi
  set_endpoint "https://staging.beyonic.com/api/payments"
  set_api_version "v1"
end