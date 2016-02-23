require 'mongoid/history'

module ActiveTriples
  class MongoidStrategy

    ##
    # Roll back last change and update source graph
    # @return [Boolean] return whether the rollback was successful
    def undo!
      return false if history_tracks.empty?

      document.undo!
      source.clear
      reload
    end

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