require 'spec_helper'

describe BeyonicApi::Webhook do
  describe ".crate" do
    let(:payload) {
      {
        event: "payment.status.changed",
        target: "https://my.callback.url/"
      }
    }

    subject {
      BeyonicApi.api_key = "my-authorization-token"
      BeyonicApi::Webhook.create(payload)
    }

    context 'Success response' do
      before { 
        stub_request(:post, "https://staging.beyonic.com/api/webhooks").to_return(
          body: File.new('spec/examples/webhooks/create_response.json'))
      }

      it { 
        is_expected.to have_requested(:post, "https://staging.beyonic.com/api/webhooks").with(
            headers: {"Authorization" => "Token my-authorization-token", "Beyonic-Version" => "v1"}
          )
      }
      it { is_expected.to be_an(BeyonicApi::Webhook) }

      it { is_expected.to have_attributes(id: 2, user: 2) }
    end

    context 'Bad request' do
      before { 
        stub_request(:post, "https://staging.beyonic.com/api/webhooks").to_return(
          body: File.new('spec/examples/webhooks/create_invalid_response.json'), 
          status: 400
        )
      }

      subject {
        -> {
          BeyonicApi.api_key = "my-authorization-token"
          BeyonicApi::Webhook.create(payload)
        }
      }
      it { 
        is_expected.to raise_error(BeyonicApi::AbstractApi::ApiError)
      }
    end

    context 'Unauthorized' do
      before { 
        stub_request(:post, "https://staging.beyonic.com/api/webhooks").to_return(
          body: File.new('spec/examples/invalid_token_error.json'), 
          status: 401
        )
      }

      subject {
        -> {
          BeyonicApi.api_key = "my-authorization-token"
          BeyonicApi::Webhook.create(payload)
        }
      }
      it { 
        is_expected.to raise_error
      }
    end

  end

  describe ".list" do
    subject {
      BeyonicApi.api_key = "my-authorization-token"
      BeyonicApi::Webhook.list
    }

    context 'Success response' do
      before { 
        stub_request(:get, "https://staging.beyonic.com/api/webhooks").to_return(
          body: File.new('spec/examples/webhooks/list_response.json'))
      }

      it { 
        is_expected.to have_requested(:get, "https://staging.beyonic.com/api/webhooks").with(
            headers: {"Authorization" => "Token my-authorization-token", "Beyonic-Version" => "v1"}
          )
      }
      it { is_expected.to be_an(Array) }
      it { is_expected.to have(2).items }

      it { is_expected.to all(be_an(BeyonicApi::Webhook)) }
    end

    context 'Unauthorized' do
      before { 
        stub_request(:get, "https://staging.beyonic.com/api/webhooks").to_return(
          body: File.new('spec/examples/invalid_token_error.json'), 
          status: 401
        )
      }

      subject {
        -> {
          BeyonicApi.api_key = "my-authorization-token"
          BeyonicApi::Webhook.list
        }
      }
      it { 
        is_expected.to raise_error
      }
    end
  end

  describe ".get" do
    subject {
      BeyonicApi.api_key = "my-authorization-token"
      BeyonicApi::Webhook.get(2)
    }

    context 'Success response' do
      before { 
        stub_request(:get, "https://staging.beyonic.com/api/webhooks/2").to_return(
          body: File.new('spec/examples/webhooks/get_response.json'))
      }

      it { 
        is_expected.to have_requested(:get, "https://staging.beyonic.com/api/webhooks/2").with(
            headers: {"Authorization" => "Token my-authorization-token", "Beyonic-Version" => "v1"}
          )
      }
      it { is_expected.to be_an(BeyonicApi::Webhook) }

      it { is_expected.to have_attributes(id: 2, user: 2) }
    end

    context 'Unauthorized' do
      before { 
        stub_request(:get, "https://staging.beyonic.com/api/webhooks/23").to_return(
          body: File.new('spec/examples/invalid_token_error.json'), 
          status: 401
        )
      }

      subject {
        -> {
          BeyonicApi.api_key = "my-authorization-token"
          BeyonicApi::Webhook.get(2)
        }
      }
      it { 
        is_expected.to raise_error
      }
    end

    context 'Forbidden' do
      before { 
        stub_request(:get, "https://staging.beyonic.com/api/webhooks/666").to_return(
          body: File.new('spec/examples/no_permissions_error.json'), 
          status: 403
        )
      }

      subject {
        -> {
          BeyonicApi.api_key = "my-authorization-token"
          BeyonicApi::Webhook.get(666)
        }
      }
      it { 
        is_expected.to raise_error
      }
    end
  end

  describe ".update" do
    let(:payload) {
      {
        event: "payment.status.changed",
        target: "https://my.callback2.url/"
      }
    }

    subject {
      BeyonicApi.api_key = "my-authorization-token"
      BeyonicApi::Webhook.update(2, target: "https://my.callback2.url/")
    }

    context 'Success response' do
      before { 
        stub_request(:patch, "https://staging.beyonic.com/api/webhooks/2").to_return(
          body: File.new('spec/examples/webhooks/update_response.json'))
      }

      it { 
        is_expected.to have_requested(:patch, "https://staging.beyonic.com/api/webhooks/2").with(
            headers: {"Authorization" => "Token my-authorization-token", "Beyonic-Version" => "v1"}
          )
      }
      it { is_expected.to be_an(BeyonicApi::Webhook) }

      it { is_expected.to have_attributes(id: 2, target: "https://my.callback2.url/") }
    end


    context 'Bad request' do
      before { 
        stub_request(:patch, "https://staging.beyonic.com/api/webhooks/3").to_return(
          body: File.new('spec/examples/webhooks/create_invalid_response.json'), 
          status: 400
        )
      }

      subject {
        -> {
          BeyonicApi.api_key = "my-authorization-token"
          BeyonicApi::Webhook.update(3, event: "wrongevent")
        }
      }
      it { 
        is_expected.to raise_error(BeyonicApi::AbstractApi::ApiError)
      }
    end


    context 'Forbidden' do
      before { 
        stub_request(:patch, "https://staging.beyonic.com/api/webhooks/666").to_return(
          body: File.new('spec/examples/no_permissions_error.json'), 
          status: 403
        )
      }

      subject {
        -> {
          BeyonicApi.api_key = "my-authorization-token"
          BeyonicApi::Webhook.update(666, target: "https://my.callback2.url/")
        }
      }
      it { 
        is_expected.to raise_error
      }
    end

    context 'Unauthorized' do
      before { 
        stub_request(:patch, "https://staging.beyonic.com/api/webhooks/23").to_return(
          body: File.new('spec/examples/invalid_token_error.json'), 
          status: 401
        )
      }

      subject {
        -> {
          BeyonicApi.api_key = "my-authorization-token2"
          BeyonicApi::Webhook.update(2, target: "https://my.callback2.url/")
        }
      }
      it { 
        is_expected.to raise_error
      }
    end
  end


  describe ".delete" do

    subject {
      BeyonicApi.api_key = "my-authorization-token"
      BeyonicApi::Webhook.delete(2)
    }

    context 'Success response' do
      before { 
        stub_request(:delete, "https://staging.beyonic.com/api/webhooks/2").to_return(
          status: 204)
      }

      it { 
        is_expected.to have_requested(:delete, "https://staging.beyonic.com/api/webhooks/2").with(
            headers: {"Authorization" => "Token my-authorization-token", "Beyonic-Version" => "v1"}
          )
      }
      it { is_expected.to be_truthy }

    end

    context 'Forbidden' do
      before { 
        stub_request(:delete, "https://staging.beyonic.com/api/webhooks/666").to_return(
          body: File.new('spec/examples/no_permissions_error.json'), 
          status: 403
        )
      }

      subject {
        -> {
          BeyonicApi.api_key = "my-authorization-token"
          BeyonicApi::Webhook.delete(666)
        }
      }
      it { 
        is_expected.to raise_error
      }
    end

    context 'Unauthorized' do
      before { 
        stub_request(:delete, "https://staging.beyonic.com/api/webhooks/23").to_return(
          body: File.new('spec/examples/invalid_token_error.json'), 
          status: 401
        )
      }

      subject {
        -> {
          BeyonicApi.api_key = "my-authorization-token2"
          BeyonicApi::Webhook.delete(2)
        }
      }
      it { 
        is_expected.to raise_error
      }
    end
  end
end