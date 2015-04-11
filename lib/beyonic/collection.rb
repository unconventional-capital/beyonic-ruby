require 'ostruct'
class Beyonic::Collection < OpenStruct
  include Beyonic::AbstractApi
  set_endpoint_resource "collections"

  def self.claim(amount, payload={})
    self.list(
      payload.merge({claim: true, amount: amount})
    )
  end
end
