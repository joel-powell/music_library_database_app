require 'sinatra'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/' do
    erb(:index)
  end

  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all

    erb(:albums)
  end

  get '/albums/new' do
    repo = ArtistRepository.new
    @artists = repo.all

    erb(:new_album)
  end

  get '/artists/new' do
    erb(:new_artist)
  end

  get '/albums/:id' do
    album_repo = AlbumRepository.new
    artist_repo = ArtistRepository.new
    @album = album_repo.find(params[:id])
    @artist = artist_repo.find(@album.artist_id)

    erb(:album)
  end

  post '/albums' do
    # check that POST request contains necessary parameters
    return status 400 unless all_album_params?

    repo = AlbumRepository.new
    @album = Album.new
    @album.title = params[:title]
    @album.release_year = params[:release_year]
    @album.artist_id = params[:artist_id]
    repo.create(@album)

    erb(:album_created)
  end

  post '/artists' do
    # check that POST request contains necessary parameters
    return status 400 unless all_artist_params?

    repo = ArtistRepository.new
    @artist = Artist.new
    @artist.name = params[:name]
    @artist.genre = params[:genre]
    repo.create(@artist)

    erb(:artist_created)
  end

  get '/artists' do
    repo = ArtistRepository.new
    @artists = repo.all

    erb(:artists)
  end

  get '/artists/:id' do
    repo = ArtistRepository.new
    @artist = repo.find(params[:id])

    erb(:artist)
  end

  private

  def all_album_params?
    %i[title release_year artist_id].all? { params.key?(_1) }
  end

  def all_artist_params?
    %i[name genre].all? { params.key?(_1) }
  end
end
