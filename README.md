# Defend-and-Build

A Roblox project template repository with automated CI/CD pipeline for code quality and testing.

## CI/CD Pipeline

The GitHub Actions workflow automatically runs on every push and pull request:

1. **Format Check** - StyLua verifies code formatting
2. **Lint** - Selene analyzes code for potential issues
3. **Run Tests** - Executes headless test suite using TestEZ and Lemur

All checks must pass before code can be merged.

## Testing

This repository uses **TestEZ** for unit testing and **Lemur** for headless Roblox environment simulation. Tests are executed via `scripts/run_tests.lua` during CI.

### Running Tests Locally

To run tests on your local machine:

```bash
lua scripts/run_tests.lua
```

**Requirements:**
- Lua 5.1
- LuaRocks
- LuaFileSystem (`luarocks install luafilesystem`)

## Project Structure

- `.github/workflows/` - CI/CD pipeline configuration
- `scripts/` - Build and test automation scripts
- `tests/` - Test files using TestEZ
- `src/` - Source code organized by Roblox services
- `default.project.json` - Rojo project configuration