require 'spec_helper'
require 'traceur'

describe Traceur do

  describe ".watch_paths" do
    it "expects a block" do
      expect{ Traceur.watch_paths('.+', ".")}.to raise_error NoBlockError
    end
  end
end


