require 'active_triples/mongoid_strategy/trackable'
require 'spec_helper'

options = { clients: { default: { database: 'active_triples', hosts: ['localhost:27017'] } } }
Mongoid.load_configuration(options)
Mongo::Logger.logger.level = Logger::INFO

describe ActiveTriples::MongoidStrategy::Trackable do
  let(:rdf_source) { ActiveTriples::Resource.new }
  let(:subject) { described_class.new(rdf_source) }

  before :each do
    Mongoid.purge!
  end

  it_behaves_like 'a persistence strategy'

  shared_examples 'track history' do
    describe '#track_history?' do
      it 'evaluates true on success' do
        expect(subject.track_history?).to be_truthy
      end
    end

    describe '#history_tracks' do
      it 'contains no history' do
        expect(subject.history_tracks).to be_empty
      end
    end

    describe '#undo!' do
      it 'evaluates false on success' do
        expect(subject.undo!).to be_falsey
      end
    end
  end

  include_examples 'track history'

  context 'with statements' do
    before do
      rdf_source << RDF::Statement(rdf_source.to_term, RDF::Vocab::DC.title, 'moomin')
      subject.persist!
    end

    include_examples 'track history'

    context 'with uncommitted changes' do
      before do
        rdf_source << RDF::Statement(rdf_source.to_term, RDF::Vocab::DC.alternative, 'Mumintrollet pa kometjakt')
      end

      describe '#persist!' do
        it 'adds a change to the history' do
          expect { subject.persist! }
            .to change { subject.history_tracks.count }.from(0).to(1)
        end
      end

      describe '#undo!' do
        before do
          subject.persist!
        end

        it 'evaluates true on success' do
          expect(subject.undo!).to be_truthy
        end

        it 'restores graph to previous state' do
          subject.undo!

          expect(subject.source.statements)
              .to contain_exactly RDF::Statement(rdf_source.to_term, RDF::Vocab::DC.title, 'moomin')
        end
      end
    end
  end

end
