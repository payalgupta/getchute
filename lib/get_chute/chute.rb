module Chute
  class GCChute < GCResource
    
    CHUTE_STATUS =  {
                      "401" => "Password Protected",
                      "200" => "Public"
                    }
    
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
      Chute::GCAsset.perform(self.class.get("/chutes/#{id}/assets"))
    end
    
    # def add_assets(asset_ids)
    #   response = self.class.post("/chutes/#{id}/add_assets", :asset_ids => "#{asset_ids}")
    #   response.is_success
    # end
    
    def remove_assets(asset_ids)
      response = self.class.post("/chutes/#{id}/assets/remove", :asset_ids => asset_ids)
      response.is_success
    end
    
    def add_comment(text, asset_id)
      comment = Chute::GCComment.new
      comment.perform(self.class.post("/chutes/#{id}/assets/#{asset_id}/comments", {:comment => "test comment by payal"}))
      comment
    end
    
    def comments(asset_id)
      Chute::GCComment.perform(self.class.get("/chutes/#{id}/assets/#{asset_id}/comments"))
    end
    
    def resource_name
      'chutes'
    end
    
    #================================================#
    # Class Methods                                  #
    #================================================#
    
    def self.fetch_status(shortcut)
      chute     = Chute::GCChute.new
      response  = get("/chutes/#{shortcut}/public/assets.js")
      CHUTE_STATUS[response.status] || "InAccessible"
    end
    
    def self.find_by_shortcut(shortcut)
      chute = Chute::GCChute.new
      chute.perform(get("/chutes/#{shortcut}"))
    end
    
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