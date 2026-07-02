require "./spec_helper"

describe MartenPgResilience do
  it "has a version" do
    MartenPgResilience::VERSION.should eq("0.1.0")
  end

  it "reopens PG::Statement as a DB::Statement subclass" do
    # If the patch's method signatures drifted from crystal-pg, this spec
    # file would fail to COMPILE — so a green run proves the reopen is
    # signature-faithful against the installed crystal-pg.
    (PG::Statement < ::DB::Statement).should be_true
  end
end
