require "sinatra"
require "yaml"
require "flickraw"

configure do
  config = YAML.load_file("config/flickr.yml") 
  FlickRaw.api_key = "#{config["api_key"]}"
  FlickRaw.shared_secret = "#{config["secret"]}"
end

get '/' do
  "Hello Ben"
end

get '/:tag' do
  images = flickr.photos.search({:tags => params[:tag], :per_page => 1, :sort => "interestingness-desc"}) #sort (Optional) The order in which to sort returned photos. Deafults to date-posted-desc (unless you are doing a radial geo query, in which case the default sorting is by ascending distance from the point specified). The possible values are: date-posted-asc, date-posted-desc, date-taken-asc, date-taken-desc, interestingness-desc, interestingness-asc, and relevance.
  if images.size > 0 then
    "<img src=#{FlickRaw.url images.photo.first}> #{params[:tag]}"
  else
    "No photos matched those tags"
  end
end

get '/*/and/*' do
  images = flickr.photos.search({:tags => params[:splat], :per_page => 1, :sort => "interestingness-desc"}) #sort (Optional) The order in which to sort returned photos. Deafults to date-posted-desc (unless you are doing a radial geo query, in which case the default sorting is by ascending distance from the point specified). The possible values are: date-posted-asc, date-posted-desc, date-taken-asc, date-taken-desc, interestingness-desc, interestingness-asc, and relevance.
  if images.size > 0 then
    "<img src=#{FlickRaw.url images.photo.first}> #{params[:splat]}"
  else
    "No photos matched those tags"
  end
end