module CouchRest
  module Model
    module Config
      class Model
        def initialize
          @environments = {}
        end

        def method_missing(environment, *args, &block)
          return @environments[environment] if args.length == 0
          server = args.length == 2 ? args.last : CouchRest::Model::Config.server
          @environments[environment] = server.database! args.first
        end
      end
    end
  end
end
