# BeyonicApi

Ruby API wrapper for http://beyonic.com

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'beyonic_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install beyonic_api

## Usage
To start using API you must setup your api key

```ruby
BeyonicApi.api_key = "my-authorization-token"
```

Now you can create payment

```ruby
BeyonicApi::Payment.create(
    phonenumber: "+256773712831",
    amount: "100.2",
    currency: "UGX",
    description: "Per diem payment",
    payment_type: "money",
    callback_url: "https://my.website/payments/callback",
    metadata: "{'id': '1234', 'name': 'Lucy'}"
)
```

After successeful creation you will get object Payment with id.

Also you can list all your payments or get one by id

```ruby
BeyonicApi::Payment.list
BeyonicApi::Payment.get(123)
```

Apart from everything else, you can manage Webohooks to define URLs on your server that notifications should be sent to.
```ruby
#Create
BeyonicApi::Webhook.create(
    event: "payment.status.changed",
    target: "https://my.callback.url/"
)

#Update by id
BeyonicApi::Webhook.update(2, 
    target: "https://mynew.callback.url/")
    
#Delete by id
BeyonicApi::Webhook.delete(2)
```

You can find more detailed API description here http://support.beyonic.com/category/api/