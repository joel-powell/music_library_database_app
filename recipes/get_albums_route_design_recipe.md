# GET /albums Route Design Recipe

## 1. Design the Route Signature

Method: GET
Path: /ablums

## 2. Design the Response

```
Doolittle
Surfer Rosa
Waterloo
Super Trouper
Bossanova
Lover
Folklore
I Put a Spell on You
Baltimore
Here Comes the Sun
Fodder on My Wings
Ring Ring
```

## 3. Write Examples

```
# Request:

GET /albums

# Expected response:

Doolittle
Surfer Rosa
Waterloo
Super Trouper
Bossanova
Lover
Folklore
I Put a Spell on You
Baltimore
Here Comes the Sun
Fodder on My Wings
Ring Ring
```

## 4. Encode as Tests Examples

```ruby
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context 'GET /albums' do
    it 'should return the list of albums' do
      response = get('/albums')

      expected_response = <<~RES.chomp
        Doolittle
        Surfer Rosa
        Waterloo
        Super Trouper
        Bossanova
        Lover
        Folklore
        I Put a Spell on You
        Baltimore
        Here Comes the Sun
        Fodder on My Wings
        Ring Ring
      RES

      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end
  end
end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.