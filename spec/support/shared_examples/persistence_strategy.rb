# frozen_string_literal: true
shared_examples 'a persistence strategy' do
  shared_context 'with changes' do
    before do
      subject.source << RDF::Statement.new(RDF::Node.new, RDF::Vocab::DC.title, 'moomin')
    end
  end

  describe '#persist!' do
    it 'evaluates true on success' do
      expect(subject.persist!).to be_truthy
    end

    context 'with changes' do
      include_context 'with changes'

      it 'evaluates true on success' do
        expect(subject.persist!).to be_truthy
      end
    end
  end

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
    it 'marks resource as destroyed' do
      subject.destroy
      expect(subject).to be_destroyed
    end
  end

  describe '#destroyed?' do
    it 'is false' do
      expect(subject).not_to be_destroyed
    end
  end

  describe '#reload' do
    it 'returns true when both persistence and object are empty' do
      expect(subject.reload).to be true
    end
  end
end
