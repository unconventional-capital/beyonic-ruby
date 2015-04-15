# Gem development
## Adding new api model

To create new api model you should create new file like lib/beyonic/new_model.rb:
```ruby
require 'ostruct'
class Beyonic::NewModel < OpenStruct
# Inherit OpenStruct for the model
# http://ruby-doc.org/stdlib-2.0/libdoc/ostruct/rdoc/OpenStruct.html

  include Beyonic::AbstractApi
  # Include AbstractApi module with standard CRUD methods

  set_endpoint_resource "newmodel"
  # Endpoint defenition in our case resulting endpoint will be
  # https://app.beyonic.com/api/newmodel
end
```
Also we need to require our model in "lib/beyonic.rb":
```ruby
require "beyonic/new_model"
```

## Testing

### Specs execution
```sh
$ rspec
Run options: include {:focus=>true}

All examples were filtered out; ignoring {:focus=>true}
...............................................................................

Finished in 0.58883 seconds (files took 0.60764 seconds to load)
79 examples, 0 failures

Coverage report generated for RSpec to ~/beyonic-ruby/coverage. 86 / 86 LOC (100.0%) covered.
```

You can get detailed coverage report at coverage/index.html, after tests has been ran.

### API mocking
For mocks [VCR](https://github.com/vcr/vcr) is used.
All recorded API interactions cassettes located on fixtures/vcr_cassettes/ folder.

They can be deleted, in this case on next tests run specs will access to real API and cassettes will be recorded again.