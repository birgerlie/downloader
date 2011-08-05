SPEC_DIR = File.dirname(__FILE__)
Dir["#{SPEC_DIR}/../lib/*.rb"].each { |f| require f }
Dir["#{SPEC_DIR}/../lib/**/*.rb"].each { |f| require f }


