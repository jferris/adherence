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

    def perform(controller, format)
      assert_valid_format(format)
      scenarios = perform_behaviors_on(controller)
      consequences_for(format, scenarios.flatten.compact).each do |consequence|
        perform_consequence_on(controller, consequence)
      end
    end

    def consequences_for(format, scenarios)
      results = []
      consequences.each do |consequence|
        if perform?(consequence, format, scenarios)
          results.reject! {|existing| existing.conflicts_with?(consequence) }
          results << consequence
        end
      end
      results
    end

    private

    def perform?(consequence, format, scenarios)
      consequence.performs_as?(format) &&
        scenarios.detect {|scenario| consequence.performs_when?(scenario) }
    end

    def perform_behaviors_on(controller)
      behaviors.collect do |behavior|
        controller.send(behavior)
      end
    end

    def perform_consequence_on(controller, consequence)
      controller.instance_eval(&consequence)
    end

    def assert_valid_format(format)
      unless formats.include?(format) || formats.include?(:all)
        raise ArgumentError, "Unrecognized format: #{format}"
      end
    end
  end
end
