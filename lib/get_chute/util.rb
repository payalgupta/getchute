module Util
  def self.unparse(options)
    JSON.unparse(options)
  end
end

class Hash
  def +(add)
    temp = {}
    add.each{|k,v| temp[k] = v}
    self.each{|k,v| temp[k] = v}
    temp
  end
end