module Chute
  class GCCollection < Array
    def append(array)
      self.concat(array)
      self.uniq!
    end
  end
end