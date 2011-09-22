module Chute
  class GCUser < GCResource
    attr_accessor :id,
                  :name,
                  :email,
                  :login,
                  :avatar,
                  :notification_photos,
                  :notification_comments,
                  :notification_invites#,
                  #:assets,
                  #:storage

    #================================================#
    # Attribute Accessors                            #
    #================================================#

    def initialize(attributes = {})
      super
      @id                     = attributes[:id]
      @name                   = attributes[:name]
      @email                  = attributes[:email]
      @login                  = attributes[:login]
      @notification_photos    = attributes[:notification_photos]
      @notification_invites   = attributes[:notification_invites]
      @notification_comments  = attributes[:notification_comments]
    end
    
    #================================================#
    # Instance Methods                               #
    #================================================#
    def resource_name
      "me"
    end
    
    def resource_path
      "#{resource_name}"
    end
    
    def accounts
      Chute::GCAccount.perform(self.class.get("/#{id}/accounts"))
    end
    
    def assets
      Chute::GCAsset.perform(self.class.get("/#{id}/assets"))
    end
    
    def bundles
      Chute::GCBundle.perform(self.class.get("/#{id}/bundles"))
    end
    
    def chutes
      Chute::GCChute.perform(self.class.get("/#{id}/chutes"))
    end
    
    def parcels
      Chute::GCParcel.perform(self.class.get("/#{id}/parcels"))
    end
    
    #below collections aren't working yet, there classes still ned to be implemented
    
    def hearts
      Chute::GCChute.perform(self.class.get("/#{id}/hearts"))
    end
    
    def devices
      Chute::GCAsset.perform(self.class.get("/#{id}/devices"))
    end
    
    def notices
      Chute::GCAsset.perform(self.class.get("/#{id}/notices"))
    end
    
    #================================================#
    # Class Methods                                  #
    #================================================#
    
    def class_path
      "me"
    end
    
    def self.me
      user = Chute::GCUser.new
      user.perform(get("/info")) ? user : false
    end 
    
  end
end