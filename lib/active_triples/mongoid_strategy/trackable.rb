require 'mongoid/history'

module ActiveTriples
  class MongoidStrategy

    private

    ##
    # Make the delegate class trackable
    def enable_tracking
      @collection.send :include, Mongoid::History::Trackable
      @collection.track_history

      # Allow accessing #history_tracks directly
      self.class.send(:delegate, :history_tracks, to: :document)
    end

    ##
    # Mongoid model for tracking changes to persisted `Mongoid::Documents`.
    class HistoryTracker
      include Mongoid::History::Tracker
    end
  end
end