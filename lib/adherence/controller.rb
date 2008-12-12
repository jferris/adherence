module Adherence
  module Controller

    def self.included(base) #:nodoc:
      base.class_eval do
        extend ClassMethods
        include InstanceMethods
      end
    end

    module InstanceMethods
      def format
        :default
      end

      protected

      def perform(action_name)
        self.class.actions[action_name].perform(self, format)
      end
    end

    module ClassMethods
      def actions
        @actions ||= {}
      end

      protected

      def performs(*action_names)
        options = action_names.last.is_a?(Hash) ? action_names.pop : {}
        formats = [options.delete(:as) || :all].flatten
        action_names.each do |action_name|
          template = ActionTemplate[action_name]
          self.actions[action_name] = template.build(formats)
          define_method(action_name) { perform(action_name) }
        end
      end
    end

  end
end
