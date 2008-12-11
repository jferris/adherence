require File.join(File.dirname(__FILE__), '..', 'spec_helper')

module Adherence

  describe ActionTemplate do
    before do
      @block    = lambda {}
      @template = ActionTemplate.new(&@block)
    end

    it "should have a block to prepare an action" do
      @template.block.should == @block
    end

    it "should yield a new action to its block when building" do
      @template.block = lambda {|@action| }
      @template.build
      @action.should be_instance_of(Action)
    end

    it "should return an action when building" do
      @template.build.should be_instance_of(Action)
    end

    it "should build an action with the specified format list" do
      @template.build([:one, :two]).formats.should == [:one, :two]
    end
  end

  describe ActionTemplate, "being created without a block" do
    def create
      ActionTemplate.new
    end

    it "should raise an error" do
      lambda { create }.should raise_error
    end
  end

  describe ActionTemplate, "after being registered" do
    before do
      @name     = :template_name
      @template = ActionTemplate.new {}
      ActionTemplate.register(@name, @template)
    end

    it "should be accessible by name" do
      ActionTemplate[@name].should == @template
    end
  end

  describe ActionTemplate do
    it "should raise an error when looking for an unregistered template" do
      lambda { ActionTemplate[:unregistered_name] }.should raise_error
    end
  end

end

describe Adherence, "after creating an action template" do
  before do
    Adherence::ActionTemplate.templates = {}
    @name     = :example
    @block    = lambda {}
    @template = Adherence.action(@name, &@block)
  end

  it "should register the template" do
    Adherence::ActionTemplate[@name].should == @template
  end
  
  it "should create a template using the passed block" do
    @template.block.should == @block
  end
end
