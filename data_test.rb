require 'linkeddata'
require 'csv'
require 'tmpdir'

graph = RDF::Graph.load(File.join(File.dirname(__FILE__), "dataset-1612.rdf"))

query = RDF::Query.new({
  :entry => {
    RDF::URI("http://www.data.gov/semantic/data/alpha/1612/dataset-1612.rdf#pay_grade") => :pay_grade,
    RDF::URI("http://www.data.gov/semantic/data/alpha/1612/dataset-1612.rdf#total_female") => :total_female,
    RDF::URI("http://www.data.gov/semantic/data/alpha/1612/dataset-1612.rdf#total_male") => :total_male
  }
})

file_name = "Active_duty_marital_data.csv"
file = File.join(Dir.tmpdir, file_name)

CSV.open(file, "w") do |csv|
  csv << ["pay_grade", "total_female", "total_male"]
end

query.execute(graph).each do |solution|
  CSV.open(file, "a") do |csv|
    csv << [solution.pay_grade, solution.total_female, solution.total_male]
  end
end