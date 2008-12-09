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
      last_hash = args.last.is_a?(Hash) ? args.pop : nil
      options   = last_hash || {}
      formats   = options.delete(:as)   || :all
      scenarios = options.delete(:when) || :all
      args << last_hash unless last_hash.nil? || last_hash == {}
      consequences << Consequence.new(:method    => method,
                                      :args      => args,
                                      :formats   => formats,
                                      :scenarios => scenarios)
    end
  end
end
