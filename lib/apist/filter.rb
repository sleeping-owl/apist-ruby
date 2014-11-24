class Apist
  class Filter

    attr :node
    attr :method
    attr :resource

    def initialize(node, method)
      @node = node
      @method = method
      @resource = method.resource
    end

    # @return [Apist::Filter]
    def text
      guard_crawler
      @node.text
    end

    # @return [Apist::Filter]
    def html
      guard_crawler
      @node.inner_html
    end

    # @return [Apist::Filter]
    def filter(selector)
      guard_crawler
      @node.css selector
    end

    # @return [Apist::Filter]
    def filter_nodes(selector)
      guard_crawler
      @node.filter selector
    end

    # @return [Apist::Filter]
    def find(selector)
      guard_crawler
      @node.css selector
    end

    # @return [Apist::Filter]
    def children
      guard_crawler
      @node.children
    end

    # @return [Apist::Filter]
    def prev
      guard_crawler
      prev_all[0]
    end

    # @return [Apist::Filter]
    def prev_all
      guard_crawler
      sibling 'previous'
    end

    # @return [Apist::Filter]
    def next
      guard_crawler
      next_all[0]
    end

    # @return [Apist::Filter]
    def next_all
      guard_crawler
      sibling 'next'
    end

    # @return [Apist::Filter]
    def is(selector)
      guard_crawler
      node = get_node
      node.matches? selector
    end

    # @return [Apist::Filter]
    def closest(selector)
      guard_crawler
      node = get_node
      node.ancestors(selector).last
    end

    # @return [Apist::Filter]
    def attr(attribute)
      guard_crawler
      @node.attr attribute
    end

    # @return [Apist::Filter]
    def hasAttr(attribute)
      guard_crawler
      @node.attr(attribute) != nil
    end

    # @return [Apist::Filter]
    def eq(position)
      guard_crawler
      @node.at position
    end

    # @return [Apist::Filter]
    def first
      guard_crawler
      @node.first
    end

    # @return [Apist::Filter]
    def last
      guard_crawler
      @node.last
    end

    # @return [Apist::Filter]
    def element
      @node
    end

    # @return [Apist::Filter]
    def call(block)
      block.call @node
    end

    # @return [Apist::Filter]
    def strip
      guard_text
      @node.strip
    end

    # @return [Apist::Filter]
    def lstrip
      guard_text
      @node.lstrip
    end

    # @return [Apist::Filter]
    def rstrip
      guard_text
      @node.rstrip
    end

    # @return [Apist::Filter]
    def gsub(*several_variants)
      guard_text
      @node.send :gsub, *several_variants
    end

    # @return [Apist::Filter]
    def to_i(base = 10)
      guard_text
      @node.to_i base
    end

    # @return [Apist::Filter]
    def to_f
      guard_text
      @node.to_f
    end

    # @return [Apist::Filter]
    def exists
      !@node.empty?
    end

    # @return [Apist::Filter]
    def check(block)
      call block
    end

    # @return [Apist::Filter]
    def then(blueprint)
      return @node unless @node === true
      return @method.parse_blueprint blueprint
    end

    # @return [Apist::Filter]
    def else(blueprint)
      return @node unless @node === false
      return @method.parse_blueprint blueprint
    end

    # @return [Apist::Filter]
    def each(blueprint = nil)
      callback = blueprint
      if callback.nil?
        callback = lambda { |node, i| node }
      end

      unless callback.is_a? Proc
        callback = lambda { |node, i|
          @method.parse_blueprint blueprint.clone, node
        }
      end

      result = []
      @node.each do |node|
        result << callback.call(node, result.length)
      end
      result
    end

    private

    def is_node
      @node.is_a? Nokogiri::XML::NodeSet or @node.is_a? Nokogiri::XML::Node
    end

    def get_node
      return @node[0] if @node.is_a? Nokogiri::XML::NodeSet
      @node
    end

    def sibling(direction)
      nodes = []
      node = get_node
      while (node = node.send(direction)) != nil
        nodes << node if node.node_type === 1
      end
      nodes
    end

    def guard_text
      @node = @node.text if is_node
    end

    def guard_crawler
      unless is_node
        raise Apist::MethodError, 'Current node isnt instance of Nokogiri Node or NodeSet.'
      end
    end

  end
end