module CouchRest
  module Model
    class Base
      class << self
        def database_with_couchrest_model_config
          database_without_couchrest_model_config || CouchRest::Model::Config.for(self).current_database
        end

        alias_method_chain :database, :couchrest_model_config
      end
    end
  end
end
