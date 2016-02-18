require 'active_triples/persistence_strategies/persistence_strategy'
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
      persisted_document.destroy
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
        doc = collection.find_or_initialize_by(id: source.id)
        doc.attributes = JSON.parse(source.dump(:jsonld, standard_prefixes: true,
                                                      useNativeTypes: true))
        doc.save
      end

      @persisted = true
    end

    ##
    # Repopulates the graph from the repository.
    #
    # @return [Boolean]
    def reload
      # Retrieve document from #collection if it exists
      doc = persisted_document.first
      source << JSON::LD::API.toRDF(doc.as_document,
                                 rename_bnodes: false) unless doc.nil?
      @persisted = true
    end

    private

    ##
    # @return [Mongoid::Criteria] criteria matching the document
    def persisted_document
      collection.where(id: source.id)
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
      klass.store_in collection: source.model_name.plural
      klass
    end
  end
end
