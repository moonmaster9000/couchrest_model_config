module CouchRest
  module Model
    module Config
      class Model
        def initialize
          @environments = {}
        end
        
        def test(db=nil)
          if db.nil?
            @environments[:test]
          else
            @environments[:test] = CouchRest::Model::Config.current_server.database! db 
          end
        end

        def current_database
          @environments[CouchRest::Model::Config.environment.to_sym] || @environments[:default]
        end

        def method_missing(environment, *args, &block)
          return @environments[environment] if args.length == 0
          @environments[environment] = CouchRest::Model::Config.current_server.database! args.first
        end
      end
    end
  end
end
