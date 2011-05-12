module CouchRest
  module Model
    class Base
      class << self
        def database
          CouchRest::Model::Config.for(self).current_database
        end

        def use_database(*args)
          raise "We're sorry, but the `use_database` method is not supported with couchrest_model_config."
        end
      end
      
      def database
        CouchRest::Model::Config.for(self.class).current_database
      end
    end
  end
end
