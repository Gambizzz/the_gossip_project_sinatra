require 'csv'
require_relative 'controller'
require 'sinatra'

class Gossip
  attr_accessor :author, :content, :all_gossips, :update_author, :update_content

  def initialize(author, content)
    @content = content
    @author = author
  end

  def save 
    CSV.open("./db/gossip.csv", "ab") do |csv|
      csv << [@author, @content]
    end
  end
  
  def  self.all
    @all_gossips = []
    CSV.read("./db/gossip.csv").each do |csv_line|
      @all_gossips << Gossip.new(csv_line[0], csv_line[1])
    end
    return @all_gossips
  end

  def self.find(id)
    return self.all[id.to_i-1]
  end

  def self.update(id, update_author, update_content)
    @update_author = update_author
    @update_content = update_content
    update_gossips = Gossip.all
    CSV.open("./db/gossip.csv", "w") 
    update_gossips[id.to_i-1].author = update_author
		update_gossips[id.to_i-1].content = update_content
		update_gossips.each {|gossip| gossip.save}
  end   
end