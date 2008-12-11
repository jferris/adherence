module Adherence
  class ActionTemplate

    class << self
      attr_accessor :templates #:nodoc:
    end
    self.templates = {}

    attr_accessor :block

    def initialize(&block)
      unless block_given?
        raise ArgumentError, "Missing a block to prepare an action"
      end
      self.block = block
    end

    def build(formats = [])
      action = Action.new
      action.formats = formats
      block.call(action)
      action
    end

    def self.register(name, template)
      templates[name] = template
    end

    def self.[](name)
      templates[name] or raise ArgumentError, "No such template: #{name}"
    end

  end

  def self.action(name, &block)
    template = ActionTemplate.new(&block)
    ActionTemplate.register(name, template)
  end
end
