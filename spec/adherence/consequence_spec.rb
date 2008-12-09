require File.join(File.dirname(__FILE__), '..', 'spec_helper')

module Adherence
  describe Consequence, "when being created" do
    before do
      @options = { :method    => :example,
                   :args      => [:one, :two],
                   :formats   => [:html],
                   :scenarios => [:saved] }
    end

    def create_consequence
      lambda { Consequence.new(@options) }
    end

    it "should not raise an error with valid options" do
      create_consequence.should_not raise_error
    end

    it "should not raise an error for an empty argument list" do
      @options[:args] = []
      create_consequence.should_not raise_error
    end

    it "should raise an error with a bad option" do
      @options[:bad] = true
      create_consequence.should raise_error(ArgumentError)
    end

    it "should convert a non-array format to an array" do
      @options[:formats] = :html
      consequence = create_consequence.call
      consequence.formats.should == [:html]
    end

    %w(method args formats scenarios).each do |option|
      it "should raise an error with no value for #{option}" do
        @options.delete(option.to_sym)
        create_consequence.should raise_error(ArgumentError)
      end

      it "should raise an error with a nil value for #{option}" do
        @options[option.to_sym] = nil
        create_consequence.should raise_error(ArgumentError)
      end

      it "should assign #{option} from the constructor" do
        consequence = create_consequence.call
        consequence.send(option).should == @options[option.to_sym]
      end
    end
  end

  describe Consequence do
    before do
      @args        = [:one, :two]
      @formats     = [:html]
      @consequence = Consequence.new(:method    => :example, 
                                     :args      => @args,
                                     :formats   => @formats,
                                     :scenarios => [:saved])
    end

    it "should call its method with the given args when run" do
      klass = Class.new
      klass.class_eval do
        attr_accessor :args
        def example(*args)
          @args = args
        end
      end
      object = klass.new
      object.instance_eval(&@consequence)
      object.args.should == @args
    end

    it "should perform as a format in its format list" do
      @consequence.performs_as?(@formats.first).should be_true
    end

    it "should not perform as a format missing from its list" do
      @consequence.performs_as?(:bad_format).should be_false
    end
  end
end
