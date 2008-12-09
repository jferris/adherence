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
            consequence.formats == [:all] &&
            consequence.scenarios == [:all]
        end.should_not be_nil
      end
    end

    describe "after adding a consequence with formats" do
      before do
        @action.consequence :example, :one, :two, :as => [:html]
      end

      it "should include that consequence in its list of consequences" do
        @action.consequences.detect do |consequence|
          consequence.method == :example &&
            consequence.args == [:one, :two] &&
            consequence.formats == [:html] &&
            consequence.scenarios == [:all]
        end.should_not be_nil
      end
    end

    describe "after adding a consequence with scenarios" do
      before do
        @action.consequence :example, :one, :two, :when => [:saved]
      end

      it "should include that consequence in its list of consequences" do
        @action.consequences.detect do |consequence|
          consequence.method == :example &&
            consequence.args == [:one, :two] &&
            consequence.formats == [:all] &&
            consequence.scenarios == [:saved]
        end.should_not be_nil
      end
    end

    describe "after adding a consequence with formats and hash arguments" do
      before do
        @action.consequence :example, :one, :arg => :value, :as => [:html]
      end

      it "should include that consequence in its list of consequences" do
        @action.consequences.detect do |consequence|
          consequence.method == :example &&
            consequence.args == [:one, { :arg => :value }] &&
            consequence.formats == [:html] &&
            consequence.scenarios == [:all]
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

  describe Action, "finding consequences" do
    before do
      @action = Action.new
    end

    def consequences(format, *scenarios)
      @action.consequences_for(format, scenarios)
    end

    def consequence
      @action.consequences.last
    end

    it "should find a consequence with a good format and good scenarios" do
      @action.consequence :x, :as => [:format, :other], :when => [:good]
      consequences(:format, :good).should include(consequence)
    end

    it "should find a consequence with no format and good scenarios" do
      @action.consequence :x, :when => [:good]
      consequences(:format, :good).should include(consequence)
    end

    it "should find a consequence with good and bad scenarios" do
      @action.consequence :x, :when => [:good]
      consequences(:format, :good, :bad).should include(consequence)
    end

    it "should find a consequence with no scenarios and a good format" do
      @action.consequence :x, :as => [:format]
      consequences(:format, :good).should include(consequence)
    end

    it "should find a consequence with no scenarios or format" do
      @action.consequence :x
      consequences(:format, :good).should include(consequence)
    end

    it "should not find a consequence with good scenarios and a bad format" do
      @action.consequence :x, :as => [:format], :when => [:good]
      consequences(:bad, :good).should_not include(consequence)
    end

    it "should not find a consequence with bad scenarios and a good format" do
      @action.consequence :x, :as => [:format], :when => [:good]
      consequences(:format, :bad).should_not include(consequence)
    end

    it "should not find a consequence with bad scenarios and a bad format" do
      @action.consequence :x, :as => [:format], :when => [:good]
      consequences(:bad, :bad).should_not include(consequence)
    end
  end

  describe Action, "with several consequences" do
    before do
      @action = Action.new
      @action.behavior :behavior1
      @action.behavior :behavior2

      @action.consequence :one
      @action.consequence :two,   :as   => :format
      @action.consequence :three, :when => :good
      @action.consequence :four,  :when => :better
      @good_consequences = @action.consequences.dup

      @action.consequence :bad, :as   => :bad
      @action.consequence :bad, :when => :bad
      @bad_consequences = @action.consequences - @good_consequences
    end

    describe "being performed on a controller" do
      before do
        klass = Class.new
        klass.class_eval do 
          attr_reader :received
          def initialize; @received = []; end
          def one;   @received << :one;   end
          def two;   @received << :two;   end
          def three; @received << :three; end
          def four ; @received << :four;  end
          def bad;   @received << :bad;   end
          def behavior1
            @received << :behavior1
            [:good]
          end
          def behavior2
            @received << :behavior2
            [:better]
          end
        end
        @controller = klass.new
        
        @action.perform(@controller, :format)
      end

      it "should run each of its behaviors" do
        @controller.received.should include(:behavior1, :behavior2)
      end

      it "should run all matching consequences" do
        methods = @good_consequences.collect {|c| c.method }
        (methods - @controller.received).should == []
      end

      it "should not run any unmatched consequences" do
        @controller.received.should_not include(:bad)
      end
    end
  end

end
