# lib/exceptions.rb
module Chute
  module Exceptions
    class UnAuthorized < StandardError; end
    class InValidResponse < StandardError; end
  end
end