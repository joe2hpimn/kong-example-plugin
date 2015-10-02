local _M = {}

function _M.execute(conf)
  if conf.say_hello then
    ngx.log(ngx.ERR, "============ A World! ============")
    ngx.header["a-world"] = "a-world"
  else
    ngx.log(ngx.ERR, "============ B World! ============")
    ngx.header["b-world"] = "b-world"
  end
  ngx.log(ngx.ERR, "============ C World! ============")
  ngx.header["c-world"] = "c-world"
end

return _M