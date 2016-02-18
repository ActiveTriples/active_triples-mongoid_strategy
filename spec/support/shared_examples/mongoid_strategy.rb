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

      json_ld = JSON.parse(subject.source.dump(:jsonld))
      g = RDF::Graph.new << JSON::LD::API.toRdf(json_ld, rename_bnodes: false)

      expect(subject.source.statements)
          .to contain_exactly *g.statements
    end
  end

  describe '#reload' do
    it 're-populates graph from a persisted document' do
      g = RDF::Graph.new << subject.source.statements

      subject.persist!
      subject.source.clear
      subject.reload

      expect(subject.source.statements)
          .to contain_exactly *g.statements
    end
  end
end
