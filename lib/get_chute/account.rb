module Chute
  class GCAccount < GCResource
    
    #================================================#
    # Attribute Accessors                            #
    #================================================#
    
    attr_accessor :uid,
                  :type,
                  :email,
                  :username,
                  :access_key,
                  :chute_user_id
                  
    def initialize(attributes = {})
      @uid            = attributes[:uid]
      @email          = attributes[:email]
      @username       = attributes[:username]
      @access_key     = attributes[:access_key]
      @chute_user_id  = attributes[:chute_user_id]
    end
    
    #================================================#
    # Instance Methods                               #
    #================================================#
    
    def resource_name
      'accounts'
    end
    
    #================================================#
    # Class Methods                                  #
    #================================================#
    
    def self.class_path
      "accounts"
    end
                  
  end
end