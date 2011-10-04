module Chute
  class GCCollection < Array
    def append(single_or_array)
      if Array === single_or_array
        self.concat(single_or_array)
      else
        self << single_or_array
      end
      self.uniq!
    end
    
    def remove(single_or_array)
      if Array === single_or_array
        self.reject!{|elem| single_or_array.include?(elem)}
      else
        self.delete(single_or_array)
      end
      self.uniq!
    end
  end
end