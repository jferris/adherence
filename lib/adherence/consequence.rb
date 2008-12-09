module Adherence
  class Consequence
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
        send(method, *args)
      end
    end

    def performs_as?(format)
      formats.include?(format)
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

    def set_options(options)
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
  end
end
