require File.join(File.dirname(__FILE__), '..', 'spec_helper')

module Adherence
  describe Consequence, "when being created" do
    before do
      @options = { :method    => :example,
                   :args      => [:one, :two] }
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

    %w(method args).each do |option|
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
end
