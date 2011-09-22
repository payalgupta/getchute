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