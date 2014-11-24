class Apist
  module Error
    class Http < StandardError
      attr_reader :code, :reason, :url
      def initialize(code, reason, url)
        @code = code
        @reason = reason
        @url = url
      end
    end
  end
end