shared_examples 'a mongoid strategy' do |value|
  before do
    subject.source[RDF::Vocab::DC.title] = value
  end

  describe '#persist!' do
    it "writes graph with #{value.inspect} to #collection" do
      subject.persist!
      expect(subject.collection.all.map(&:id))
          .to contain_exactly *rdf_source.id
    end

    it 'serializes as JSON-LD' do
      subject.persist!

      # subject.document will contain JSON-LD
      g = RDF::Graph.new << JSON::LD::API.toRdf(subject.document.as_document, rename_bnodes: false)

      expect(subject.source.statements)
          .to contain_exactly *g.statements
    end
  end

  describe '#reload' do
    # TODO: refactor / clean up

    it 're-populates graph from a persisted document' do
      g = RDF::Graph.new << subject.source.statements

      subject.persist!
      subject.source.clear
      subject.reload

      expect(subject.source.statements)
          .to contain_exactly *g.statements
    end

    it 'merges persisted graph with updated statements' do
      g = RDF::Graph.new << subject.source.statements
      statement = RDF::Statement(rdf_source.to_term, RDF::Vocab::DC.alternative, 'moomin')

      subject.persist!
      subject.source.clear
      subject.source << statement
      subject.reload

      expect(subject.source.statements)
          .to contain_exactly *g.statements, statement
    end
  end
end
