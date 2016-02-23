require 'active_triples/mongoid_strategy'
require 'spec_helper'

options = { clients: { default: { database: 'active_triples', hosts: ['localhost:27017'] } } }
Mongoid.load_configuration(options)
Mongo::Logger.logger.level = Logger::INFO

describe ActiveTriples::MongoidStrategy do
  let(:rdf_source) { ActiveTriples::Resource.new }
  let(:subject) { described_class.new(rdf_source) }

  before :each do
    Mongoid.purge!
  end

  it_behaves_like 'a persistence strategy'

  shared_examples 'destroy resource' do
    it 'removes the resource from the collection' do
      subject.persist!
      expect { subject.destroy }
        .to change { subject.collection.count }.from(1).to(0)
    end
  end

  describe '#destroy' do
    it 'leaves other resources unchanged' do
      # insert a new resource into the collection
      other_resource = ActiveTriples::Resource.new
      other_resource << RDF::Statement(other_resource.to_term, RDF::Vocab::DC.title, 'snorkmaiden')
      described_class.new(other_resource).persist!

      expect { subject.destroy }
        .not_to change { subject.collection.count }
    end

    context 'with statements' do
      before do
        rdf_source << RDF::Statement(rdf_source.to_term, RDF::Vocab::DC.title, 'moomin')
      end

      include_examples 'destroy resource'

      context 'with subjects' do
        before do
          subject.source.set_subject! RDF::URI('http://example.org/moomin')
        end

        include_examples 'destroy resource'
      end
    end
  end

  include_context 'with literals'
  include_context 'with objects'
end
