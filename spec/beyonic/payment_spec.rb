require 'spec_helper'

describe Beyonic::Payment do
  describe ".crate" do
    let(:payload) {
      {
        phonenumber: "+256773712831",
        amount: "100.2",
        currency: "UGX",
        description: "Per diem payment",
        payment_type: "money",
        callback_url: "https://my.website/payments/callback",
        metadata: "{'id': '1234', 'name': 'Lucy'}"
      }
    }

    subject {
      Beyonic.api_key = "my-authorization-token"
      Beyonic::Payment.create(payload)
    }

    context 'Success response' do
      before { 
        stub_request(:post, "https://staging.beyonic.com/api/payments").to_return(
          body: File.new('spec/examples/payments/create_response.json'))
      }

      it { 
        is_expected.to have_requested(:post, "https://staging.beyonic.com/api/payments").with(
            headers: {"Authorization" => "Token my-authorization-token", "Beyonic-Version" => "v1"}
          )
      }
      it { is_expected.to be_an(Beyonic::Payment) }

      it { is_expected.to have_attributes(id: 3607, state: 'new') }
    end

    context 'Bad request' do
      before { 
        stub_request(:post, "https://staging.beyonic.com/api/payments").to_return(
          body: File.new('spec/examples/payments/create_invalid_response.json'), 
          status: 400
        )
      }

      subject {
        -> {
          Beyonic.api_key = "my-authorization-token"
          Beyonic::Payment.create(payload)
        }
      }
      it { 
        is_expected.to raise_error(Beyonic::AbstractApi::ApiError)
      }
    end

    context 'Unauthorized' do
      before { 
        stub_request(:post, "https://staging.beyonic.com/api/payments").to_return(
          body: File.new('spec/examples/invalid_token_error.json'), 
          status: 401
        )
      }

      subject {
        -> {
          Beyonic.api_key = "my-authorization-token"
          Beyonic::Payment.create(payload)
        }
      }
      it { 
        is_expected.to raise_error
      }
    end

  end

  describe ".list" do
    subject {
      Beyonic.api_key = "my-authorization-token"
      Beyonic::Payment.list
    }

    context 'Success response' do
      before { 
        stub_request(:get, "https://staging.beyonic.com/api/payments").to_return(
          body: File.new('spec/examples/payments/list_response.json'))
      }

      it { 
        is_expected.to have_requested(:get, "https://staging.beyonic.com/api/payments").with(
            headers: {"Authorization" => "Token my-authorization-token", "Beyonic-Version" => "v1"}
          )
      }
      it { is_expected.to be_an(Array) }

      it { is_expected.to all(be_an(Beyonic::Payment)) }
    end

    context 'Unauthorized' do
      before { 
        stub_request(:get, "https://staging.beyonic.com/api/payments").to_return(
          body: File.new('spec/examples/invalid_token_error.json'), 
          status: 401
        )
      }

      subject {
        -> {
          Beyonic.api_key = "my-authorization-token"
          Beyonic::Payment.list
        }
      }
      it { 
        is_expected.to raise_error
      }
    end
  end

  describe ".get" do
    subject {
      Beyonic.api_key = "my-authorization-token"
      Beyonic::Payment.get(23)
    }

    context 'Success response' do
      before { 
        stub_request(:get, "https://staging.beyonic.com/api/payments/23").to_return(
          body: File.new('spec/examples/payments/get_response.json'))
      }

      it { 
        is_expected.to have_requested(:get, "https://staging.beyonic.com/api/payments/23").with(
            headers: {"Authorization" => "Token my-authorization-token", "Beyonic-Version" => "v1"}
          )
      }
      it { is_expected.to be_an(Beyonic::Payment) }

      it { is_expected.to have_attributes(id: 23, state: 'processed_with_errors') }
    end

    context 'Unauthorized' do
      before { 
        stub_request(:get, "https://staging.beyonic.com/api/payments/23").to_return(
          body: File.new('spec/examples/invalid_token_error.json'), 
          status: 401
        )
      }

      subject {
        -> {
          Beyonic.api_key = "my-authorization-token"
          Beyonic::Payment.get(23)
        }
      }
      it { 
        is_expected.to raise_error
      }
    end

    context 'Unauthorized' do
      before { 
        stub_request(:get, "https://staging.beyonic.com/api/payments/666").to_return(
          body: File.new('spec/examples/no_permissions_error.json'), 
          status: 403
        )
      }

      subject {
        -> {
          Beyonic.api_key = "my-authorization-token"
          Beyonic::Payment.get(666)
        }
      }
      it { 
        is_expected.to raise_error
      }
    end
  end

  describe "#save" do
    context 'new object' do
      subject { Beyonic::Payment }
      let(:payload) {
        {
          phonenumber: "+256773712831",
          amount: "100.2",
          currency: "UGX",
          description: "Per diem payment",
          payment_type: "money",
          callback_url: "https://my.website/payments/callback",
          metadata: "{'id': '1234', 'name': 'Lucy'}"
        }
      } 

      before {
        allow(subject).to receive(:create)
        subject.new(payload).save
      }     

      it { 
        is_expected.to have_received(:create).with(payload)
      }
    end

    context 'loaded object' do
      subject { Beyonic::Payment }
      before { 
        stub_request(:get, "https://staging.beyonic.com/api/payments/23").to_return(
          body: File.new('spec/examples/payments/get_response.json'))
        allow(subject).to receive(:update)

        temp = subject.get(23)
        temp.description = "foo"
        temp.save
      }

      it { 
        is_expected.to have_received(:update).with(23, hash_including(description: "foo"))
      }
    end
  end
end
