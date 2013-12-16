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

not_found do      
  response['Access-Control-Allow-Origin'] = '*'
  content_type :json
  '{"error":{"message": "Whoops! You requested a method that wasn\'t available"})'
end

get "/" do
  erb :howto
end

get "/client" do
  erb :client
end

get "/list" do    
  response['Access-Control-Allow-Origin'] = '*'
  content_type :json
  companies = Company.order("id ASC")
  redirect "/create" if companies.empty?  
  companies.to_json  
end

post "/create" do
  response['Access-Control-Allow-Origin'] = '*'  
  content_type :json
  params = JSON.parse(request.env["rack.input"].read)
  companies = Company.new(params) 
  if companies.save   
    status 201
  else
    status 400
  end
end

put "/update/:id" do    
  response['Access-Control-Allow-Origin'] = '*'
  content_type :json
  companies = Company.find(params[:id])
  return status 404 if companies.nil?
  params = JSON.parse(request.env["rack.input"].read)
  companies.update(params)    
  companies.save
  status 202
end

get "/details/:id" do
  response['Access-Control-Allow-Origin'] = '*'
  content_type :json
  companies = Company.find_by_id(params[:id])        
  companies.to_json 
end

delete "/delete/:id" do 
  response['Access-Control-Allow-Origin'] = '*' 
  companies = Company.find(params[:id])    
  return "NIL" if companies.nil?
  companies.delete
end