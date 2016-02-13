shared_examples 'a mongoid strategy' do |value|
  before do
    subject.obj[RDF::Vocab::DC.title] = value
  end

  describe '#persist!' do
    it 'writes to #collection' do
      subject.persist!
      expect(subject.collection.all.map(&:id))
          .to contain_exactly *rdf_source.id
    end

    it 'serializes as JSON-LD' do
      subject.persist!

      json_ld = JSON.parse(subject.obj.dump(:jsonld))
      g = RDF::Graph.new << JSON::LD::API.toRdf(json_ld, rename_bnodes: false)

      expect(subject.obj.statements)
          .to contain_exactly *g.statements
    end
  end

  describe '#reload' do
    it 're-populates from a persisted object' do
      g = RDF::Graph.new << subject.obj.statements

      subject.persist!
      subject.obj.clear
      subject.reload

      expect(subject.obj.statements)
          .to contain_exactly *g.statements
    end
  end
end
