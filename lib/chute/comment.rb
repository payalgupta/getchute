module Chute
  class GCComment < GCResource
    attr_accessor :id,
                  :status,
                  :comment
    
    def initialize(attributes = {})
      super
      @id             = id
      @status         = status
      @comment        = comment
    end
    
    def resource_name
      "comments"
    end
    
    def save
      raise NotImplementedError
    end
    
    def update
      raise NotImplementedError
    end
    
    def class_path
      "comments"
    end
  end
end