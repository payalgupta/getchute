module Chute
  class GCChute < GCResource
    
    #================================================#
    # Attribute Accessors                            #
    #================================================#
    
    attr_accessor :id,
                  :name,
                  :shortcut,
                  :created_at,
                  :updated_at,
                  :assets_count,
                  :members_count,
                  :contributors_count,
                  :moderate_photos,
                  :moderate_members,
                  :moderate_comments,
                  :permission_view, 
                  :permission_add_photos,
                  :permission_add_members,
                  :permission_add_comments
    
    def initialize(attributes = {})
      super
      @id                       = attributes[:id]
      @name                     = attributes[:name]
      @shortcut                 = attributes[:shortcut]
      
      @created_at               = attributes[:created_at]
      @updated_at               = attributes[:updated_at]
      
      @assets_count             = attributes[:assets_count]
      @members_count            = attributes[:members_count]
      @contributors_count       = attributes[:contributors_count]
      
      @moderate_photos          = attributes[:moderate_photos]
      @moderate_members         = attributes[:moderate_members]
      @moderate_comments        = attributes[:moderate_comments]
      
      @permission_view          = attributes[:permission_view]
      @permission_add_photos    = attributes[:permission_add_photos]
      @permission_add_members   = attributes[:permission_add_members]
      @permission_add_comments  = attributes[:permission_add_comments]
    end
    
    #================================================#
    # Instance Methods                               #
    #================================================#
    
    def assets
      Chute::GCAsset.perform(get("/chutes/#{id}/assets"))
    end
    
    def resource_name
      'chutes'
    end
    
    #================================================#
    # Class Methods                                  #
    #================================================#
    
    def self.find_by_id(id)
      chute = Chute::GCChute.new
      chute.perform(get("/chutes/#{id}")) ? chute : false
    end
    
    def self.all
      self.perform(get("/me/chutes"))
    end
    
    def self.class_path
      "chutes"
    end
    
  end
end