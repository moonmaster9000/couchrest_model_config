module CouchRest
  module Model
    class Base
      class_eval <<-EOS, __FILE__, __LINE__ + 1
        def self.database
          CouchRest::Model::Config.for(self).current_database
        end
        
        def database
          CouchRest::Model::Config.for(self.class).current_database
        end
      EOS
      
      class << self
        def use_database(*args)
          raise "We're sorry, but the `use_database` method is not supported with couchrest_model_config."
        end
      end
    end
  end
end
