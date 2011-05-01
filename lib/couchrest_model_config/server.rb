module CouchRest
  module Model
    module Config
      module Server
        extend self
        
        def reset
          @environments = {}
        end

        def default(uri=nil)
          if uri.nil?
            environments[:default] ||= CouchRest.new
          else
            environments[:default] = CouchRest.new uri
          end
        end

        def test(uri=nil)
          if uri.nil?
            environments[:test]
          else
            environments[:test] = CouchRest.new uri
          end
        end

        def method_missing(environment, *args, &block)
          case args.length
            when 0 then environments[environment]
            when 1 then environments[environment] = CouchRest.new args.first
            else raise "Too many arguments passed to the '#{environment}' server configuration!"
          end
        end

        private
        def environments
          @environments ||= {}
        end
      end
    end
  end
end
