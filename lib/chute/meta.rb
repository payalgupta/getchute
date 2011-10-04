module Chute
  class GCMeta < GCResource
    
    attr_accessor :id,
                  :meta_data,
                  :for_resource
    
    def initialize(attributes, parent)
      @meta_data    = attributes || {}
      @for_resource = parent
    end  
  end
end