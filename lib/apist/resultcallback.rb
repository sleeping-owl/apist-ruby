require 'apist/error/method'
require 'apist/filter'

class Apist
  class ResultCallback

    attr_reader :name
    attr_reader :arguments

    def initialize(name, arguments)
      @name = name
      @arguments = arguments
    end

    def apply(node, method)
      return apply_to_array node, method if node.is_a? Array

      return node.to_s if @name === :to_s

      filter = Apist::Filter.new node, method
      return filter.send @name, *@arguments if filter.respond_to? @name

      resource = method.resource
      return call_resource_method node, resource if resource.respond_to? @name

      return node.send @name, *@arguments if node.respond_to? @name

      raise Apist::Error::Method, "Method '#{@name}' was not found"
    end

    def apply_to_array(array, method)
      result = []
      array.each do |node|
        result << apply(node, method)
      end
      return result
    end

    def call_resource_method(node, resource)
      arguments = @arguments.unshift node
      resource.send @name, *arguments
    end

  end
end