require 'sinatra'
 
get '/:nombre' do
  "Hola, #{params[:nombre]}"
end