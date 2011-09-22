module Chute
  class GCParcel < GCResource
    attr_accessor :id,
                  :status,
                  :share_url,
                  :device_id,
                  :asset_count
    
    def initialize(attributes = {})
      super
      @id          = id
      @status      = status
      @share_url   = share_url
      @device_id   = device_id
      @asset_count = assets_count
    end
    
    #================================================#
    # Instance Methods                               #
    #================================================#
    
    def resource_name
      "parcels"
    end
    
    #================================================#
    # Class Methods                                  #
    #================================================#
    
    def class_path
      "parcels"
    end
    
    def self.find_by_id(id)
      parcel = Chute::GCParcel.new
      parcel.perform(get("/parcels/#{id}"))
      parcel
    end

  end
end