require 'sinatra'
require 'sinatra/activerecord'
require 'json'

db = URI.parse('postgres://user:password@localhost/db')

ActiveRecord::Base.establish_connection(
  :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  :host     => db.host,
  :username => db.user,
  :password => db.password,
  :database => db.path[1..-1],
  :encoding => 'utf8'
)

class Company < ActiveRecord::Base
end

get "/" do  
  content_type :json
  companies = Company.order("id ASC")
  redirect "/create" if companies.empty?
  companies.to_json  
end

get "/create" do
    status 400  
end

post "/create" do
  content_type :json
  companies = Company.new(params[:company])
  if companies.save   
    status 201
  else
    status 400
  end
end

post "/update/:id" do  
  content_type :json
  companies = Company.find(params[:id])
  return "NIL" if companies.nil?
  companies.update(params[:company])  
  if companies.save  
    status 202  
  else
    status 400
  end
end

get "/details/:id" do
    content_type :json
    companies = Company.find_by_id(params[:id])    
    companies.to_json 
end

get '/hw' do 
    ("hello world").to_json;
end
