module CouchRest
  module Model
    module Config
      class Model
        attr_reader :environments

        def initialize(klass)
          @klass = klass
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
          current_env = CouchRest::Model::Config.environment.to_sym

          # if this model was configured, that takes precedence
          db = @environments[current_env] || @environments[:default]

          # next any of it's ancestors take precedence
          @klass.ancestors.each do |a| 
            db ||= 
              CouchRest::Model::Config.for(a).send(current_env) || 
              CouchRest::Model::Config.for(a).default
          end unless db

          # next, the default database takes precedence
          db ||= CouchRest::Model::Config.default_database
          db 
        end

        def method_missing(environment, *args, &block)
          return @environments[environment] if args.length == 0
          couch_server, database = parse_database_config args.first
          @environments[environment] = couch_server.database! database
        end

        private
        def parse_database_config(db)
          if db.match(%r{^(https?://.*)/(.*)$})
            [CouchRest.new($1), $2]
          else
            [CouchRest::Model::Config.current_server, db]
          end
        end
      end
    end
  end
end
