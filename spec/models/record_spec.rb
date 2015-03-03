describe Record do
  before :each do
    @sensor = Sensor.new title: 'Test Title', description: 'Test Description'
  end

  it 'should require a value' do
    record = @sensor.records.new
    expect(record.valid?).to be false
    expect(record.errors.full_messages).to eq ([
      "Value can't be blank"
    ])
  end
end
