describe 'Record#valid?' do
  subject { @sensor.records.new(value: value) }
  before :each do
    @sensor = Sensor.new(
      title: 'Test Title',
      description: 'Test Description'
    )
  end

  context 'value not set' do
    let(:value) { nil }

    it 'should be invalid' do
      expect(subject).not_to be_valid
      expect(subject).to have(1).errors_on(:value)
    end
  end

  context 'value set to non number' do
    let(:value) { 'Not a number' }

    it 'should cast the value' do
      expect(subject.value).to eq('Not a number'.to_f)
    end
  end

  context 'value set to number type' do
    let(:value) { 10.0 }

    it 'it should be valid' do
      expect(subject).to be_valid
    end
  end
end

