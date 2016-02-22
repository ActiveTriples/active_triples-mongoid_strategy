require 'mongoid/history'

module ActiveTriples
  class MongoidStrategy

    private

    ##
    # Make the delegate class trackable
    def enable_tracking
      collection.send :include, Mongoid::History::Trackable
      collection.track_history

      class << self
        delegate :history_tracks, to: :document
        delegate :track_history?, to: :collection
      end
    end

    ##
    # Mongoid model for tracking changes to persisted `Mongoid::Documents`.
    class HistoryTracker
      include Mongoid::History::Tracker
    end
  end
end