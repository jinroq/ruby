require_relative 'spec_helper'
ruby_version_is ""..."3.4" do
  load_extension("data")

  describe "CApiAllocSpecs (a class with an alloc func defined)" do
    it "calls the alloc func" do
      @s = CApiAllocSpecs.new
      @s.wrapped_data.should == 42 # not defined in initialize
    end
  end

  describe "CApiWrappedStruct" do
    before :each do
      @s = CApiWrappedStructSpecs.new
    end

    it "wraps with Data_Wrap_Struct and Data_Get_Struct returns data" do
      a = @s.wrap_struct(1024)
      @s.get_struct(a).should == 1024
    end

    describe "RDATA()" do
      it "returns the struct data" do
        a = @s.wrap_struct(1024)
        @s.get_struct_rdata(a).should == 1024
      end

      it "allows changing the wrapped struct" do
        a = @s.wrap_struct(1024)
        @s.change_struct(a, 100)
        @s.get_struct(a).should == 100
      end

      it "raises a TypeError if the object does not wrap a struct" do
        -> { @s.get_struct(Object.new) }.should raise_error(TypeError)
      end
    end

    describe "rb_check_type" do
      it "does not raise an exception when checking data objects" do
        a = @s.wrap_struct(1024)
        @s.rb_check_type(a, a).should == true
      end
    end

    describe "DATA_PTR" do
      it "returns the struct data" do
        a = @s.wrap_struct(1024)
        @s.get_struct_data_ptr(a).should == 1024
      end
    end
  end
end
