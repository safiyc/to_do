require('sinatra')
require('sinatra/reloader')
also_reload('lib/**/*.rb')
# require('./lib/item')
require('./lib/task')
require('./lib/list')
require("pg")

DB = PG.connect({:dbname => "to_do_test"})

get('/') do
  erb(:index)
end

get("/lists/new") do
  erb(:list_form)
end

post("/lists") do
  name = params.fetch("name")
  list = List.new({:name => name, :id => nil})
  list.save
  erb(:list_success)
end

get('/lists') do
  @lists = List.all()
  erb(:lists)
end

get('/lists/:id') do
  @list = List.find(params.fetch("id").to_i())
  erb(:list)
end

get("/lists/:id/edit") do
  @list = List.find(params.fetch("id").to_i())
  erb(:list_edit)
end

post("/tasks") do
  description = params.fetch("description")
  list_id = params.fetch("list_id").to_i()
  @list = List.find(list_id)
  @task = Task.new({:description => description, :list_id => list_id})
  @task.save()
  erb(:task_success)
end

get("/lists/:id/edit") do
  @list = List.find(params.fetch("id").to_i())
  erb(:list_edit)
end

patch("/lists/:id") do
  name = params.fetch("name")
  @list = List.find(params.fetch("id").to_i())
  @list.update({:name => name})
  erb(:list)
end

delete("/lists/:id") do
  @list = List.find(params.fetch("id").to_i)
  @list.delete
  @lists = List.all
  erb(:index)
end

# get('/') do
#   @list = Item.all()
#   erb(:list)
# end
#
# post('/') do
#   name = params["name"]
#   item = Item.new(name)
#   item.save()
#   @list = Item.all()
#   erb(:list)
# end
#
# get('/items/:id') do
#   @item = Item.find(params[:id])
#   erb(:item)
# end
