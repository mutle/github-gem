require File.dirname(__FILE__) + '/spec_helper'

describe "GitHub.parse_options" do
  it "should parse --bare options" do
    args = ["--bare", "--test"]
    GitHub.parse_options(args).should == {:bare => true, :test => true}
    args.should == []
  end

  it "should parse options intermixed with non-options" do
    args = ["text", "--bare", "more text", "--option", "--foo"]
    GitHub.parse_options(args).should == {:bare => true, :option => true, :foo => true}
    args.should == ["text", "more text"]
  end

  it "should parse --foo=bar style options" do
    args = ["--foo=bar", "--bare"]
    GitHub.parse_options(args).should == {:bare => true, :foo => "bar"}
    args.should == []
  end

  it "should stop parsing options at --" do
    args = ["text", "--bare", "--", "--foo"]
    GitHub.parse_options(args).should == {:bare => true}
    args.should == ["text", "--foo"]
  end

  it "should handle duplicate options" do
    args = ["text", "--foo=bar", "--bare", "--foo=baz"]
    GitHub.parse_options(args).should == {:foo => "baz", :bare => true}
    args.should == ["text"]
  end

  it "should handle duplicate --bare options surrounding --" do
    args = ["text", "--bare", "--", "--bare"]
    GitHub.parse_options(args).should == {:bare => true}
    args.should == ["text", "--bare"]
  end

  it "should handle no options" do
    args = ["text", "more text"]
    GitHub.parse_options(args).should == {}
    args.should == ["text", "more text"]
  end

  it "should handle no args" do
    args = []
    GitHub.parse_options(args).should == {}
    args.should == []
  end

  it "should not set up debugging when --debug not passed" do
    GitHub.stub!(:load)
    GitHub.stub!(:invoke)
    GitHub.activate(['default'])
    GitHub.should_not be_debug
  end

  it "should set up debugging when passed --debug" do
    GitHub.stub!(:load)
    GitHub.stub!(:invoke)
    GitHub.activate(['default', '--debug'])
    GitHub.should be_debug
  end
end
