require 'apist/resultcallback'
require 'apist/error/method'

class Apist
  class Selector

    undef_method :to_s

    attr_reader :selector
    attr_reader :result_method_chain

    def initialize(selector)
      @selector = selector
      @result_method_chain = []
    end

    def method_missing(name, *arguments)
      add_callback name, arguments
    end

    # @param [Apist::Method] method
    def get_value(method, root_node = nil)
      root_node = method.crawler if root_node.nil?
      if @selector == '*'
        result = root_node
      else
        result = root_node.css @selector
      end
      apply_result_callback_chain result, method
    end

    private

    def apply_result_callback_chain(node, method)
      add_callback 'text' if @result_method_chain.empty?

      trace_stack = []
      @result_method_chain.each do |result_callback|
        begin
          trace_stack << result_callback
          node = result_callback.apply node, method
        rescue Apist::Error::Method => e
          return nil if method.resource.suppress_exceptions
          raise Apist::Error::Method, create_exception_message(e, trace_stack)
        end
      end
      return node
    end

    def add_callback(name, arguments = [])
      @result_method_chain << Apist::ResultCallback.new(name, arguments)
      return self
    end

    def create_exception_message(e, trace_stack)
      message = e.message + ": filter(#{@selector})"
      trace_stack.each do |callback|
        message += ".#{callback.name.to_s}"
        message += '(' + callback.arguments.join(', ') + ')' unless callback.arguments.empty?
      end
      return message
    end

  end
end