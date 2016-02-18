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

  context 'with behaviour' do
    it_behaves_like 'a persistence strategy'

    describe '#persisted?' do
      context 'before persist!' do
        it 'returns false' do
          expect(subject).not_to be_persisted
        end
      end

      context 'after persist!' do
        it 'returns true' do
          subject.persist!
          expect(subject).to be_persisted
        end
      end
    end

    describe '#destroy' do
      shared_examples 'destroy resource' do
        it 'removes the resource from the collection' do
          subject.persist!
          expect { subject.destroy }
            .to change { subject.collection.count }.from(1).to(0)
        end
      end

      it 'marks resource as destroyed' do
        subject.destroy
        expect(subject).to be_destroyed
      end

      it 'leaves other resources unchanged' do
        # insert a new resource into the collection
        other_resource = ActiveTriples::Resource.new
        other_resource << RDF::Statement(other_resource.to_term, RDF::Vocab::DC.title, 'snorkmaiden')
        described_class.new(other_resource).persist!

        expect { subject.destroy }
          .not_to change { subject.collection.count }
      end

      context 'with statements' do
        before { rdf_source << RDF::Statement(rdf_source.to_term, RDF::Vocab::DC.title, 'moomin') }

        include_examples 'destroy resource'

        context 'with subjects' do
          before do
            subject.source.set_subject! RDF::URI('http://example.org/moomin')
          end

          include_examples 'destroy resource'
        end
      end
    end

    describe '#destroyed?' do
      it 'is false' do
        expect(subject).not_to be_destroyed
      end
    end

    describe '#reload' do
      it 'returns true when both collection and object are empty' do
        expect(subject.reload).to be true
      end
    end
  end

  context 'with literals' do
    literals = [
      # Non-localized String
      'Comet in Moominland',
      RDF::Literal('Mumintrollet pa kometjakt'),

      # Localized string
      RDF::Literal('Mumintrollet pa kometjakt', language: :sv),

      # Boolean
      true,
      RDF::Literal("false", datatype: RDF::XSD.boolean),

      # Integer
      16_589_991,
      RDF::Literal("31415927", datatype: RDF::XSD.integer),

      # Float
      12.345,
      RDF::Literal("67.890", datatype: RDF::XSD.double),

      # Symbol
      :something,
      RDF::Literal("else", datatype: RDF::XSD.token),

      # Date
      Date.new(1946),
      RDF::Literal("1947-01-01", datatype: RDF::XSD.date),

      # DateTime
      DateTime.new(1951, 2, 3, 4, 5, 6),
      RDF::Literal("1952-03-04T05:06:07Z", datatype: RDF::XSD.dateTime),

      # Time
      Time.now,
      RDF::Literal(Time.now, datatype: RDF::XSD.time),

      # URI
      RDF::URI('http://foo.org'),
    ]

    it_behaves_like 'a mongoid strategy', literals

    # Test persistence with various types of value
    literals.each { |value| it_behaves_like 'a mongoid strategy', value }
  end

  context 'with objects' do
    objects = [
      ActiveTriples::Resource.new,
      ActiveTriples::Resource.new('http://example.uri/'),
    ]

    it_behaves_like 'a mongoid strategy', objects

    # Test persistence with various types of value
    objects.each { |value| it_behaves_like 'a mongoid strategy', value }
  end
end
