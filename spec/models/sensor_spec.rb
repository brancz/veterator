describe 'Sensor#valid?' do
  context 'when invalid' do
    subject { Sensor.new }

    it 'should not require a title and a description' do
      expect(subject).not_to be_valid
      expect(subject).to have(1).errors_on(:title)
      expect(subject).to have(1).errors_on(:description)
    end

    it 'should use linear interpolation by default' do
      expect(subject.chart_type).to eq('linear')
    end
  end
end

