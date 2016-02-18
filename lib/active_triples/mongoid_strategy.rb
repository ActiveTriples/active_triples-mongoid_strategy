require 'active_triples/persistence_strategies/persistence_strategy'
require 'active_triples/mongoid_strategy/history_tracker'
require 'active_triples/mongoid_strategy/version'
require 'mongoid'
require 'json/ld'

module ActiveTriples
  ##
  # Persistence strategy for projecting `RDFSource` to `Mongoid::Documents`.
  class MongoidStrategy
    include PersistenceStrategy

    # @!attribute [r] source
    #   the RDFSource to persist with this strategy
    # @!attribute [r] collection
    #   the Mongoid::Document class that the resource
    #   will project itself on when persisting
    attr_reader :source, :collection

    ##
    # @param source [RDFSource] the `RDFSource` to persist with the strategy.
    def initialize(source)
      @source = source
      @collection = set_klass
    end

    ##
    # Delete the Document from the collection
    def erase_old_resource
      document.destroy if document
    end

    ##
    # Delete the Document from the collection
    # and mark the Resource as destroyed
    def destroy
      super { source.clear }
      erase_old_resource
    end

    ##
    # Persists the resource to the repository
    #
    # @return [true] returns true if the save did not error
    def persist!
      # Persist resource as a @graph
      unless source.empty?
        # Use a flattened form to avoid assigning weird attributes (eg. 'dc:title')
        json = JSON.parse(source.dump(:jsonld, standard_prefixes: true, useNativeTypes: true))
        document.attributes = JSON::LD::API.flatten(json, json['@context'], rename_bnodes: false)

        document.save
      end

      @persisted = true
    end

    ##
    # Repopulates the graph from the repository.
    #
    # @return [Boolean]
    def reload
      # Retrieve document from #collection if it exists
      source << JSON::LD::API.toRDF(document.as_document, rename_bnodes: false) if document
      @persisted = true
    end

    private

    ##
    # @return [Mongoid::Criteria] criteria matching the document
    def document
      @doc ||= collection.find_or_initialize_by(id: source.id)
    end

    ##
    # Return the delegated class for the resource's model
    def set_klass
      klass_name = source.model_name.name.demodulize.to_sym

      if self.class.constants.include? klass_name
        return self.class.const_get(klass_name)
      else
        return delegate_klass(klass_name)
      end
    end

    ##
    # Define a Mongoid::Document delegate class
    def delegate_klass(klass_name)
      klass = self.class.const_set(klass_name, Class.new)
      klass.send :include, Mongoid::Document
      klass.send :include, Mongoid::Attributes::Dynamic
      klass.send :include, Mongoid::History::Trackable
      klass.store_in collection: source.model_name.plural
      klass.track_history
      klass
    end
  end
end
