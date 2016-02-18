require 'mongoid/history'

module ActiveTriples
  class MongoidStrategy
    ##
    # Mongoid model for tracking changes to persisted `Mongoid::Documents`.
    class HistoryTracker
      include Mongoid::History::Tracker
    end
  end
end