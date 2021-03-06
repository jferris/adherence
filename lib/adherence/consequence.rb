module Adherence
  class Consequence
    class << self
      attr_accessor :conflicts
    end
    self.conflicts = Hash.new { [] }

    def self.conflict(*methods)
      methods.each do |method|
        conflicts_for_method = methods - [method]
        self.conflicts[method] += conflicts_for_method
      end
    end

    attr_reader :method, :args, :formats, :scenarios

    def initialize(options)
      assert_valid_options!(options)
      set_options(options)
      convert_array_params
    end

    def to_proc
      method = self.method
      args   = self.args
      lambda do
        args = args.collect do |arg|
          if arg.is_a?(Symbol)
            send(arg)
          else
            arg
          end
        end
        send(method, *args)
      end
    end

    def performs_as?(format)
      formats.include?(format) || formats.include?(:all)
    end

    def performs_when?(scenario)
      scenarios.include?(scenario) || scenarios.include?(:all)
    end

    def conflicts_with?(consequence)
      consequence.method == method ||
        defined_conflicts.include?(consequence.method)
    end

    private

    def assert_valid_options!(options) #:nodoc:
      options.reject! {|opt, val| val.nil? }
      missing_options = valid_options - options.keys
      if missing_options.size > 0
        raise ArgumentError, "Missing arguments: #{missing_options.inspect}"
      end

      unknown_options = options.keys - valid_options
      if unknown_options.size > 0
        raise ArgumentError, "Unknown arguments: #{unknown_options.inspect}"
      end
    end

    def set_options(options) #:nodoc:
      options.each do |opt, val|
        instance_variable_set("@#{opt}", val)
      end
    end

    def convert_array_params
      @formats   = [@formats].flatten
      @scenarios = [@scenarios].flatten
    end

    def valid_options #:nodoc:
      [:method, :args, :formats, :scenarios]
    end

    def defined_conflicts #:nodoc:
      self.class.conflicts[method]
    end
  end
end
