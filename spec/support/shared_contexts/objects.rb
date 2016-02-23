shared_context 'with objects' do
  objects = [
    ActiveTriples::Resource.new,
    ActiveTriples::Resource.new('http://example.uri/'),
  ]

  it_behaves_like 'a mongoid strategy', objects

  # Test persistence with various types of value
  objects.each { |value| it_behaves_like 'a mongoid strategy', value }
end
