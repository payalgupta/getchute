module Chute
  class GCResource
    attr_accessor :attributes, :errors, :meta
    
    def initialize(attributes = {})
      @errors     = []
      @attributes = attributes
      @meta     ||= get_meta_data if (id and has_meta?)
    end
    
    #================================================#
    # Instance Methods                               #
    #================================================#
    
    def save
      perform(self.class.post("/#{resource_name}", {"#{resource_name.singularize}" => attributes}))
    end
    
    def update
      perform(self.class.put("/#{resource_name}/#{id}", {"#{resource_name.singularize}" => attributes}))
    end
    
    def destroy
      perform(self.class.delete("/#{resource_name}/#{id}"))
    end
    
    def resource_name;end
    
    def valid?
      errors.size == 0
    end
    
    def new?
      !self.id.blank?
    end
    
    def perform(response)
      if response.is_success
        response.data.each do |key, value|
          attributes[key.to_sym] = response.data[key] if self.instance_variable_defined?("@#{key}")
        end
        return true
      else
        self.errors = response.errors
        return false
      end
    end
    
    #================================================#
    # Class Methods                                  #
    #================================================#
    
    def self.all;end
    
    def self.find_by_id(id);end
    
    def self.search(key, value=nil)
      self.perform(get("/#{class_path}/meta/#{key}/#{value}"))
    end
    
    def self.perform(response)
      collection = Chute::GCCollection.new
      if response.is_success
        data = response.data["#{class_path}"] || response.data
        data.each do |item|
          new_resource = self.new
          item.each do |key, value|
            new_resource.attributes[key.to_sym] = value if new_resource.instance_variable_defined?("@#{key}")
          end
          collection << new_resource
        end
        return collection
      else
        #payal says: create an exception for such cases
        #self.errors = response.errors
        return false
      end
    end
    
    #================================================#
    # Meta data Methods                              #
    #================================================#
    
    def has_meta?
      true
    end
    
    # set meta data
    # in case key available, set the value of the key
    # or if key is nil, set the full meta data
    def set_meta_data(data, key=nil)
      response = (key.blank? and Hash === data) ? (self.class.post("/#{resource_name}/#{id}/meta", data.to_json)) : (self.class.post("/#{resource_name}/#{id}/meta/#{key}", data))
      if response.is_success
        Hash === data ? (self.meta = data) : (self.meta[key]  = data)
        true
      else
        false
      end
    end

    # get meta data
    # in case key available, return the value of the key
    # or if key is nil, return the full meta data
    def get_meta_data(key=nil)
      if key.blank?
        response  = self.class.get("/#{resource_name}/#{id}/meta")
      else
        response  = self.class.get("/#{resource_name}/#{id}/meta/#{key}")
      end
      if response.is_success
        Hash === response.data ? (self.meta = response.data) : (self.meta[key]  = response.data)
      else
        false
      end
    end
    
    def delete_meta_data(key = nil)
      if key.blank?
        response = self.class.delete("/#{resource_name}/#{id}/meta")
        response.is_success ? self.meta = {} : false
      else
        response = self.class.delete("/#{resource_name}/#{id}/meta/#{key}")
        response.is_success ? self.meta.delete(key) : false
      end
    end
    
    #================================================#
    # Request/Response Methods                       #
    #================================================#
    
    def self.get(url, params=nil)
      @request = GCRequest.new()
      @request.get(url, params)
    end

    def self.post(url, params=nil)
      @request = GCRequest.new()
      @request.post(url, params)
    end
    
    def self.put(url, params=nil)
      @request = GCRequest.new()
      @request.put(url, params)
    end
    
    def self.delete(url, params=nil)
      @request = GCRequest.new()
      @request.delete(url, params)
    end
    
    protected
    
    #=====================================================#
    # keeps attributes hash in sync with class attributes #
    #=====================================================#
    class << self
      def attr_accessor(*names)
        super
        names.each do |name|
          self.class_eval do
            define_method name do
              attributes[name]
            end

            define_method("#{name}=") do |value|
              attributes[name] = value
            end
          end
        end
      end
    end
    
    private
    
    def sync_meta(response, data=nil)
      if response.is_success
        data ||= response.data
        Hash === data ? (self.meta = data) : (self.meta[key]  = data)
      else
        false
      end
    end
    
  end
end