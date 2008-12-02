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

    def consequence(consequence)
      consequences << consequence
    end
  end
end
