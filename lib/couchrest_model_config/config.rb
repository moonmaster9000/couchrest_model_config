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

      def model(m, &block)
        configure_model m, &block
      end

      def models(*args, &block)
        args.each do |m|
          configure_model m, &block
        end
      end

      def reset
        @model_configs = {}
        @environment_proc = nil
        Server.reset
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
        return (@model_configs[model] ||= Model.new) if model
      end
    end
  end
end
