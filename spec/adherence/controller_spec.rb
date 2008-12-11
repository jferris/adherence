require File.join(File.dirname(__FILE__), '..', 'spec_helper')

module Adherence
  
  describe Controller do
    before do
      @klass = Class.new
      @klass.class_eval { include Controller }
    end

    it "should start with an empty list of actions" do
      @klass.actions.should == {}
    end

    it "should have a default format" do
      @klass.new.format.should == :default
    end

    describe "after defining a known action to be performed" do
      before do
        @action   = Action.new
        @template = ActionTemplate.new {}

        ActionTemplate.register(:example, @template)
        @template.stub!(:build).and_return(@action)
      end

      def define_action
        @klass.class_eval { performs :example }
      end

      after do
        ActionTemplate.templates.clear
      end

      it "should have an action with that name" do
        define_action
        @klass.actions[:example].should_not be_nil
      end

      it "should build an action using the appropriate template" do
        @template.should_receive(:build).with().and_return(@action)
        define_action
      end

      it "should assign the built action" do
        define_action
        @klass.actions[:example].should == @action
      end

      it "should perform the given action when called" do
        define_action
        controller = @klass.new
        controller.should respond_to(:example)

        @action.should_receive(:perform).with(controller, controller.format)
        controller.example
      end
    end
  end

end
