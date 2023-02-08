# frozen_string_literal: true

require 'rack/test'
require_relative '../../app'

def reset_albums_table
  seed_sql = File.read('spec/seeds/albums_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

def reset_artists_table
  seed_sql = File.read('spec/seeds/artists_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  before(:each) do
    reset_albums_table
    reset_artists_table
  end

  context 'GET /albums' do
    it 'should return a list of album links' do
      response = get('/albums')

      expected_response = [
        '<a href="/albums/1">Doolittle</a>',
        '<a href="/albums/2">Surfer Rosa</a>',
        '<a href="/albums/3">Waterloo</a>'
      ]

      expect(response.status).to eq(200)
      expect(response.body).to include(*expected_response)
    end
  end

  context 'GET /albums/:id' do
    it 'should return the HTML content for a single album' do
      response = get('/albums/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Doolittle</h1>')
      expect(response.body).to include('Release year: 1989')
      expect(response.body).to include('Artist: Pixies')
    end
  end

  context 'GET /artists' do
    it 'should return a list of artist links' do
      response = get('/artists')

      expected_response = [
        '<a href="/artists/1">Pixies</a>',
        '<a href="/artists/2">ABBA</a>',
        '<a href="/artists/3">Taylor Swift</a>',
        '<a href="/artists/4">Nina Simone</a>'
      ]

      expect(response.status).to eq(200)
      expect(response.body).to include(*expected_response)
    end
  end

  context 'GET /artists/:id' do
    it 'should return the HTML content for a single artist' do
      response = get('/artists/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Pixies</h1>')
      expect(response.body).to include('Genre: Rock')
    end
  end

  context 'POST /albums' do
    it 'should create a new album' do
      response = post(
        '/albums',
        title: 'Voyage',
        release_year: 2022,
        artist_id: 2
      )
      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/albums')
      expect(response.body).to include('Voyage')
    end
  end

  context 'POST /artists' do
    it 'should create a new artist' do
      response = post(
        '/artists',
        name: 'Wild nothing',
        genre: 'Indie'
      )
      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/artists')
      expect(response.body).to include('Wild nothing')
    end
  end
end
