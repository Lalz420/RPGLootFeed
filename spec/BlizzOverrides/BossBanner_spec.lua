describe("BossBanner module", function()

  before_each(function()
      -- Define the global G_RLF
      _G.G_RLF = {
        RLF = {}
      }
      -- Load the list module before each test
      dofile("BlizzOverrides/BossBanner.lua")
  end)

  it("TODO", function()
    assert.are.equal(true, true)
  end)
end)
