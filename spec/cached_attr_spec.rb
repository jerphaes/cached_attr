require 'spec_helper'

describe CachedAttr do

  it "simple case" do
    t = Test.new
    5.times do
      t.one.should == "1"
    end
    t._one_call_count.should == 5
    t._one_invoke_count.should == 1
  end

  it "using TTL" do
    t = Test.new
    t.two.should == "2"
    t._two_invoke_count.should == 1
    sleep(3)
    t.two.should == "2"
    t._two_invoke_count.should == 2
  end

  it "using method call" do
    t = Test.new
    t.three.should == "3"
  end

  class Test
    include CachedAttr

    cached_attr :one do
      "1"
    end

    cached_attr :two, :ttl => 2 do
      "2"
    end

    cached_attr :three, :method => :three_impl

    def three_impl
      "3"
    end
  end


end