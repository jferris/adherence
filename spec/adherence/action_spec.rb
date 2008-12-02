require File.join(File.dirname(__FILE__), '..', 'spec_helper')

module Adherence

  describe Action do
    before do
      @action = Action.new
    end

    it "should allow its format list to be assigned" do
      @action.formats = [:one, :two]
      @action.formats.should == [:one, :two]
    end

    describe "after adding a behavior" do
      before do
        @action.behavior :example
      end

      it "should include that behavior in its list of behaviors" do
        @action.behaviors.should include(:example)
      end
    end

    describe "after adding a consequence" do
      before do
        @action.consequence :example
      end

      it "should include that consequence in its list of consequences" do
        @action.consequences.should include(:example)
      end
    end
  end

  describe Action, "when newly created" do
    before do
      @action = Action.new
    end

    it "should have an empty list of formats" do
      @action.formats.should == []
    end

    it "should have an empty list of behaviors" do
      @action.behaviors.should == []
    end

    it "should have an empty list of consequences" do
      @action.consequences.should == []
    end
  end

end
