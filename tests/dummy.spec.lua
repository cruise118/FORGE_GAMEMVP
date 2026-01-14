-- Minimal TestEZ spec that always passes
-- This proves the Lemur + TestEZ wiring is working correctly

return function()
  describe("Basic functionality", function()
    it("should pass a simple test", function()
      expect(true).to.equal(true)
    end)

    it("should perform basic arithmetic", function()
      expect(2 + 2).to.equal(4)
    end)
  end)
end
