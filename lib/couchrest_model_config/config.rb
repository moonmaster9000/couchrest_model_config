module CouchRest
  module Model
    module Config
      extend self

      def environment(&block)
        block ? environment_proc(block) : environment_proc.call
      end

      def current_server
        Server.send(environment) || Server.default
      end
      
      def server(&block)
        block ? Server.instance_eval(&block) : Server
      end

      def edit(&block)
        self.instance_eval &block
      end

      def database(*args, &block)
        if args.empty?
          configure_default_database &block
        else
          args.each {|m| configure_model m, &block}
        end
      end

      def reset
        @model_configs = {}
        @environment_proc = nil
        Server.reset
      end

      def default_database
        model_configs(:default_database).send(self.environment) || model_configs(:default_database).default
      end

      def for(m)
        m = m.to_s.camelize.constantize unless m.class == Class
        model_configs(m)
      end

      def method_missing(model, *args, &block)
        model = model.to_s.camelize.constantize
        return model_configs(model) unless block
        configure_model model, &block
      end

      private
      def environment_proc(p=nil)
        if p.nil?
          @environment_proc ||= proc { Rails.env }
        else
          @environment_proc = p
        end
      end

      def configure_model(model, &block)
        model_configs(model).instance_eval &block
      end

      def model_configs(model=nil)
        @model_configs ||= {}
        return (@model_configs[model] ||= Model.new model) if model
      end

      def configure_default_database(&block)
        model_configs(:default_database).instance_eval &block
      end
    end
  end
end
