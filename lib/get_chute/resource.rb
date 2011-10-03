module Chute
  class GCResource
    attr_accessor :attributes, :errors, :meta, :prefix_options
    
    def initialize(attributes = {})
      @errors         = []
      @attributes     = attributes
      @prefix_options = {}
    end
    
    #================================================#
    # Instance Methods                               #
    #================================================#
    
    def save
      options = {}
      options["#{resource_name.singularize}"] = attributes
      options.merge!(prefix_options)
      perform(self.class.post("/#{resource_name}", options))
    end
    
    def update
      options = {}
      options["#{resource_name.singularize}"] = attributes
      options.merge!(prefix_options)
      perform(self.class.put("/#{resource_name}/#{id}", options))
    end
    
    def destroy
      response = self.class.delete("/#{resource_name}/#{id}", prefix_options)
      response.is_success
    end
    
    def resource_name
      raise NotImplementedError
    end
    
    def resource_path
      "#{resource_name}/#{id}"
    end
    
    def valid?
      errors.size == 0
    end
    
    def new?
      !self.id.blank?
    end
    
    def perform(response)
      if response.is_success
        response.data.each do |key, value|
          attributes[key.to_sym] = response.data[key] if (self.instance_variable_defined?("@#{key}") rescue nil)
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
    
    def self.all
      raise NotImplementedError
    end
    
    def self.find_by_id(id)
      raise NotImplementedError
    end
    
    def self.search(key, value=nil)
      self.perform(get("/#{class_path}/meta/#{key}/#{value}"))
    end
    
    def self.perform(response)
      collection = Chute::GCCollection.new
      if response.is_success
        data = Hash === response.data ? response.data["#{class_path}"] : response.data
        data = [] unless (data and !data.empty?)
        data.each do |item|
          new_resource = self.new
          item.each do |key, value|
            new_resource.attributes[key.to_sym] = value if (new_resource.instance_variable_defined?("@#{key}") rescue nil)
          end
          collection << new_resource
        end
        return collection
      else
        raise Chute::Exceptions::InValidResponse, response.errors
      end
    end
    
    #================================================#
    # Meta data Methods                              #
    #================================================#
    
    # Public: Set whether the resource has meta data or not
    
    def has_meta?
      true
    end
    
    # Public: Set meta data for one or more keys for the resource.
    #
    # data  - Hash or String.
    #         Hash of key/value pair to be added to the meta data.
    #         String value for a key specified as the next parameter.
    #
    # key   - Optional. String if a specific key value to be set.
    #
    # Examples
    #
    #   chute = GCChute.find_by_id(23)  
    #   # => GCChute instance
    # 
    #   For a key.
    #     chute.set_meta_data("Testing", :title)
    #     # => true
    #     chute.get_meta_data(:title)
    #     # => "Testing"
    #
    #   Add a Hash to meta data.
    #     chute.set_meta_data({:details => "Testing the methods", :source => "Mobile"})
    #     # => true
    #     chute.get_meta_data
    #     # => {:title => "Testing", :details => "Testing the methods", :source => "Mobile"}
    
    def set_meta_data(data, key=nil)
      response = (key.blank? and Hash === data) ? (self.class.post("/#{resource_path}/meta", data.to_json)) : (self.class.post("/#{resource_path}/meta/#{key}", data))
      if response.is_success
        Hash === data ? (self.meta = data) : (self.meta[key]  = data)
        true
      else
        false
      end
    end
    
    # Public: Get complete meta data or a specific key for the resource.
    #
    # key - Optional. String if a specific key value to be fetched.
    #
    # Examples
    #
    #   chute = GCChute.find_by_id(23)  
    #   # => GCChute instance
    # 
    #   With a key.
    #     chute.get_meta_data(:title)
    #     # => "Testing"
    #
    # Returns String value of meta data for a key
    #
    #   Without a key.
    #     chute.get_meta_data
    #     # => {:title => "Testing", :source => "Mobile"}
    # 
    # Returns meta data Hash without a key
    
    def get_meta_data(key=nil)
      if key.blank?
        response  = self.class.get("/#{resource_path}/meta")
      else
        response  = self.class.get("/#{resource_path}/meta/#{key}")
      end
      if response.is_success
        Hash === response.data ? (self.meta = response.data) : (self.meta[key]  = response.data)
      else
        false
      end
    end
    
    # Public: Deletes complete meta data or a specific key for the resource.
    #
    # key - Optional. String if a specific key to be deleted.
    #
    # Examples
    #
    #   chute = GCChute.find_by_id(23)  
    #   # => GCChute instance
    #
    #   chute.get_meta_data 
    #   # => {:title => "Testing", :source => "Mobile"}
    # 
    #   With a key.
    #     chute.delete_meta_data(:title)
    #     # => "Testing"
    #     chute.get_meta_data
    #     # => {:source => "Mobile"}
    #
    #   Without a key.
    #     chute.delete_meta_data
    #     # => {}
    #     chute.get_meta_data
    #     # => {}
    
    def delete_meta_data(key = nil)
      if key.blank?
        response = self.class.delete("/#{resource_path}/meta")
        response.is_success ? self.meta = {} : false
      else
        response = self.class.delete("/#{resource_path}/meta/#{key}")
        response.is_success ? self.meta.delete(key) : false
      end
    end
    
    #================================================#
    # Request/Response Methods                       #
    #================================================#
    
    # Public: Custom get request to a specific URL. 
    #
    # url     - relative url.
    # params  - parameters hash.
    # headers - headers hash.
    #
    # Returns a GCResponse.
    
    def self.get(url, params=nil, headers=nil)
      @request = GCRequest.new()
      @request.get(url, params)
    end
    
    # Public: Custom post request to a specific URL. 
    #
    # url     - relative url.
    # params  - parameters hash.
    # headers - headers hash.
    #
    # Returns a GCResponse.

    def self.post(url, params=nil, headers=nil)
      @request = GCRequest.new()
      @request.post(url, params)
    end
    
    # Public: Custom put request to a specific URL. 
    #
    # url     - relative url.
    # params  - parameters hash.
    # headers - headers hash.
    #
    # Returns a GCResponse.
    
    def self.put(url, params=nil, headers=nil)
      @request = GCRequest.new()
      @request.put(url, params)
    end
    
    # Public: Custom delete request to a specific URL. 
    #
    # url     - relative url.
    # params  - parameters hash.
    # headers - headers hash.
    #
    # Returns a GCResponse.
    
    def self.delete(url, params=nil, headers=nil)
      @request = GCRequest.new()
      @request.delete(url, params)
    end
    
    protected
    
    # Protected: Overriding attr_accessor.
    # It keeps attributes hash in sync with class attributes.

    class << self
      def attr_accessor(*names)
        super
        unless name.match(/^x_/)
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
    end
    
  end
end