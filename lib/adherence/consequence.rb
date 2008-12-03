module Adherence
  class Consequence
    attr_reader :method, :args

    def initialize(options)
      assert_valid_options!(options)
    end

    def to_proc
      method = self.method
      args   = self.args
      lambda do
        send(method, *args)
      end
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

      options.each do |opt, val|
        instance_variable_set("@#{opt}", val)
      end
    end

    def valid_options #:nodoc:
      [:method, :args]
    end
  end
end
