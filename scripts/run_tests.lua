-- Test runner using Lemur + TestEZ for headless unit testing
-- Runs tests in a simulated Roblox environment

-- Add init.lua support to package.path
package.path = package.path .. ";?/init.lua"

-- Load Lemur
local lemur = require("Packages.Lemur")

-- Create a Habitat (virtual Roblox environment - Lemur Game)
local habitat = lemur.Habitat.new()

-- Get the ReplicatedStorage service
local ReplicatedStorage = habitat.game:GetService("ReplicatedStorage")

-- Explicitly mount Packages/ directory
local PackagesFolder = lemur.Instance.new("Folder")
PackagesFolder.Name = "Packages"
PackagesFolder.Parent = ReplicatedStorage

-- Mount Lemur
local LemurFolder = lemur.Instance.new("Folder")
LemurFolder.Name = "Lemur"
LemurFolder.Parent = PackagesFolder
habitat:loadFromFs("Packages/Lemur/lib", LemurFolder)

-- Mount TestEZ
local TestEZFolder = lemur.Instance.new("Folder")
TestEZFolder.Name = "TestEZ"
TestEZFolder.Parent = PackagesFolder
habitat:loadFromFs("Packages/TestEZ/src", TestEZFolder)

-- Explicitly mount src/ directory (even if empty)
local SrcFolder = lemur.Instance.new("Folder")
SrcFolder.Name = "src"
SrcFolder.Parent = ReplicatedStorage
habitat:loadFromFs("src", SrcFolder)

-- Explicitly mount tests/ directory
local TestsFolder = lemur.Instance.new("Folder")
TestsFolder.Name = "Tests"
TestsFolder.Parent = ReplicatedStorage
habitat:loadFromFs("tests", TestsFolder)

-- Build TestEZ module manually since Lemur doesn't support script.Property for siblings
local TestBootstrap = habitat:require(TestEZFolder:FindFirstChild("TestBootstrap"))
local TestPlanner = habitat:require(TestEZFolder:FindFirstChild("TestPlanner"))
local TestRunner = habitat:require(TestEZFolder:FindFirstChild("TestRunner"))
local TextReporter = habitat:require(TestEZFolder.Reporters:FindFirstChild("TextReporter"))

-- Run tests using TestEZ components directly
print("=== Running TestEZ Tests ===")

local modules = TestBootstrap:getModules(TestsFolder)
local plan = TestPlanner.createPlan(modules)
local results = TestRunner.runPlan(plan)

-- Report results
TextReporter.report(results)

-- Exit with appropriate status code
if results.failureCount > 0 then
  print("\n✗ Tests failed!")
  os.exit(1)
else
  print("\n✓ All tests passed!")
  os.exit(0)
end
