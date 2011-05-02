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
          db = @environments[current_env] || @environments[:default]
          @klass.ancestors.each do |a| 
            db ||= 
              CouchRest::Model::Config.send(a.to_s).environments[current_env] || 
              CouchRest::Model::Config.send(a.to_s).environments[:default]
          end unless db
          db 
        end

        def method_missing(environment, *args, &block)
          return @environments[environment] if args.length == 0
          @environments[environment] = CouchRest::Model::Config.current_server.database! args.first
        end
      end
    end
  end
end
