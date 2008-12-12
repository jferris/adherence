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

    describe "after defining known actions to be performed" do
      before do
        @action_one   = Action.new
        @action_two   = Action.new
        @template_one = ActionTemplate.new {}
        @template_two = ActionTemplate.new {}

        ActionTemplate.register(:one, @template_one)
        ActionTemplate.register(:two, @template_two)

        @template_one.stub!(:build).and_return(@action_one)
        @template_two.stub!(:build).and_return(@action_two)
      end

      def define_action
        @klass.class_eval { performs :one, :two }
      end

      after do
        ActionTemplate.templates.clear
      end

      it "should have actions with the registered names" do
        define_action
        @klass.actions[:one].should_not be_nil
        @klass.actions[:two].should_not be_nil
      end

      it "should build actions using the appropriate templates" do
        @template_one.should_receive(:build).with().and_return(@action_one)
        @template_two.should_receive(:build).with().and_return(@action_two)
        define_action
      end

      it "should assign the built actions" do
        define_action
        @klass.actions[:one].should == @action_one
        @klass.actions[:two].should == @action_two
      end

      it "should perform the built action when called" do
        define_action
        controller = @klass.new

        controller.should respond_to(:one)
        controller.should respond_to(:two)

        @action_one.should_receive(:perform).with(controller, controller.format)
        @action_two.should_receive(:perform).with(controller, controller.format)

        controller.one
        controller.two
      end
    end
  end

end
