describe 'Sensor#valid?' do
  context 'when invalid' do
    it 'should not require a title and a description' do
      sensor = Sensor.new
      expect(sensor.valid?).to be false
      expect(sensor.errors.full_messages).to eq ([
        "Title can't be blank",
        "Description can't be blank"
      ])
    end
  end
end

