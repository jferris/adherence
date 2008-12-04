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

    describe "after adding a consequence without formats or scenarios" do
      before do
        @action.consequence :example, :one, :two
      end

      it "should include that consequence in its list of consequences" do
        @action.consequences.detect do |consequence|
          consequence.method == :example &&
            consequence.args == [:one, :two] &&
            consequence.formats == :all &&
            consequence.scenarios == :all
        end.should_not be_nil
      end
    end

    describe "after adding a consequence with formats" do
      before do
        @action.consequence :example, :one, :two, :formats => [:html]
      end

      it "should include that consequence in its list of consequences" do
        @action.consequences.detect do |consequence|
          consequence.method == :example &&
            consequence.args == [:one, :two] &&
            consequence.formats == [:html] &&
            consequence.scenarios == :all
        end.should_not be_nil
      end
    end

    describe "after adding a consequence with scenarios" do
      before do
        @action.consequence :example, :one, :two, :scenarios => [:saved]
      end

      it "should include that consequence in its list of consequences" do
        @action.consequences.detect do |consequence|
          consequence.method == :example &&
            consequence.args == [:one, :two] &&
            consequence.formats == :all &&
            consequence.scenarios == [:saved]
        end.should_not be_nil
      end
    end

    describe "after adding a consequence with formats and hash arguments" do
      before do
        @action.consequence :example, :one, :arg => :value, :formats => [:html]
      end

      it "should include that consequence in its list of consequences" do
        @action.consequences.detect do |consequence|
          consequence.method == :example &&
            consequence.args == [:one, { :arg => :value }] &&
            consequence.formats == [:html] &&
            consequence.scenarios == :all
        end.should_not be_nil
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
