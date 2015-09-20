require 'json_parser'
require 'securerandom'

class ItemsController < ApplicationController
  def index
    
    app = Orchestrate::Application.new("7f1aab23-01c6-4075-bd7f-5dfa0f025fdc")
    collection = app[:files]
    if !params[:query].blank?
      items = collection.search(params[:query]).find.take(10).map {|item| item[1].value}
    else
      items = collection.search("*").find.take(10).map {|item| item[1].value}
    end
    
    if request.xhr?
      render partial: "list", layout: false
    end
  end


  def create
    app = Orchestrate::Application.new("7f1aab23-01c6-4075-bd7f-5dfa0f025fdc")
    client = Orchestrate::Client.new("7f1aab23-01c6-4075-bd7f-5dfa0f025fdc")
    collection = app[:files]

    file = params[:file]
    file_json = JSON.parse(File.read(file.tempfile))
    parsed_json_arr = JsonParser.start file_json

    prepared_json = parsed_json_arr.map do |item|
      guid = SecureRandom.uuid 
      {
        path: {
          kind: "item",
          collection: "files",
          key: guid
        },
        value: item
      }
    end
    client.post("", prepared_json)

    if request.xhr?
      render text: true
    end
  end

  def clear_all
    app = Orchestrate::Application.new("7f1aab23-01c6-4075-bd7f-5dfa0f025fdc")
    collection = app[:files]
    collection.destroy!
    redirect_to items_path    
  end

end
