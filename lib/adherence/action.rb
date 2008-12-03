module Adherence
  class Action
    attr_accessor :formats, :behaviors, :consequences
    protected :behaviors=, :consequences=

    def initialize
      self.formats      = []
      self.behaviors    = []
      self.consequences = []
    end

    def behavior(behavior)
      behaviors << behavior
    end

    def consequence(method, *args)
      consequences << Consequence.new(:method => method,
                                      :args   => args)
    end
  end
end
