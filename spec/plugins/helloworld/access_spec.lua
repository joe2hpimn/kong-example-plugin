local spec_helper = require "spec.spec_helpers"
local http_client = require "kong.tools.http_client"

local STUB_GET_URL = spec_helper.STUB_GET_URL
local STUB_POST_URL = spec_helper.STUB_POST_URL

describe("HelloWorld Plugin", function()

  setup(function()
    spec_helper.prepare_db()

    spec_helper.insert_fixtures {
      api = {
        { name = "tests-helloworld3", request_host = "mockbin1.com", upstream_url = "http://mockbin.com" },
        { name = "tests-helloworld4", request_host = "mockbin2.com", upstream_url = "http://mockbin.com" }
      },
      plugin = {
        { name = "helloworld", config = { say_hello = true }, __api = 1 },
        { name = "helloworld", config = { say_hello = false }, __api = 2 },
      }
    }

    spec_helper.start_kong()
  end)

  teardown(function()
    spec_helper.drop_db()
    spec_helper.stop_kong()
  end)

  describe("Response", function()

     it("should return an a-world header with a-world value when say_hello is true", function()
        local _, status, headers = http_client.get(STUB_GET_URL, {}, {host = "mockbin1.com"})
        -- for key,value in pairs(headers) do print(key,value) end
        assert.are.equal(200, status)
        assert.are.same("a-world", headers['a-world'])
        assert.is.falsy(headers['b-world'])
        assert.is.truthy(headers['c-world'])
      end)

     it("should return an b-world header value with b-world when say_hello is false", function()
        local _, status, headers = http_client.get(STUB_GET_URL, {}, {host = "mockbin2.com"})
        -- for key,value in pairs(headers) do print(key,value) end
        assert.are.equal(200, status)
        assert.is.falsy(headers['a-world'])
        assert.are.same("b-world", headers['b-world'])
        assert.is.truthy(headers['c-world'])
      end)

     -- it("should return an Hello-World headasdasdorld!!! value when say_hello is true", function()
     --    local _, status, headers = http_client.get(STUB_GET_URL, {}, {host = "mockbin2.com"})
     --    -- for key,value in pairs(headers) do print(key,value) end
     --    assert.are.equal(200, status)
     --    assert.is.falsy(headers['A-world'])
     --    assert.is.falsy(headers['B-world'])
     --    assert.is.falsy(headers['C-world'])
     --  end)

  end)
end)