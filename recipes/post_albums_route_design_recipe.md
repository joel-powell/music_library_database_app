# POST /albums Route Design Recipe

## 1. Design the Route Signature

Method: GET
Path: /ablums
Body parameters: title, release_year, artist_id

## 2. Design the Response

```
(No content)
```

## 3. Write Examples

```
# Request:
POST /albums

# With body parameters:
title=Voyage
release_year=2022
artist_id=2

# Expected response (200 OK)
(No content)
```

## 4. Encode as Tests Examples

```ruby
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "POST /albums" do
    it 'should create a new album' do
      response = post(
        '/albums',
        title: 'Voyage',
        release_year: 2022,
        artist_id: 2
      )
      expect(response.status).to eq(200)

      response = get('/albums')
      expect(response.status).to eq(200)
      expect(response.body).to include('Voyage')
    end
  end
end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.