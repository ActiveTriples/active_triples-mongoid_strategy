shared_context 'with literals' do
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
