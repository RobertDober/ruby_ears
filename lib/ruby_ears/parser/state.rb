module RubyEars
  module Parser
    class State
      NOT_PENDING = [nil, 0]
      attr_reader :pending


      private
      def initialize
        @pending = NOT_PENDING
        
      end
    end
  end
end
