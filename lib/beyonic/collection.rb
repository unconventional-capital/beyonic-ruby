require 'ostruct'
class Beyonic::Collection < OpenStruct
  include Beyonic::AbstractApi
  set_endpoint_resource "collections"

  def self.claim(amount, phonenumber, remote_transaction_id)
    self.list(
      {
      	claim: true, 
      	amount: amount,
      	phonenumber: phonenumber,
      	remote_transaction_id: remote_transaction_id
      }
    )
  end
end
