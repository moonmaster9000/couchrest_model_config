module CouchRest
  module Model
    module Config
      extend self

      def server(couchrest_server=nil)
        @server = couchrest_server
        @server ||= CouchRest.new
      end

      def edit(&block)
        self.instance_eval &block
      end

      def model(m, &block)
        configure_model m, &block
      end

      def reset
        @model_configs = {}
        @server = nil
      end

      def method_missing(model, *args, &block)
        model = model.to_s.camelize.constantize
        return model_configs(model) unless block
        configure_model model, &block
      end

      private
      def configure_model(model, &block)
        model_configs(model).instance_eval &block
      end

      def model_configs(model=nil)
        @model_configs ||= {}
        return (@model_configs[model] ||= Model.new) if model
      end
    end
  end
end
