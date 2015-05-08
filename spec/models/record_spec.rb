RSpec.describe Record do
  before :each do
    @sensor = Sensor.create(
      title: 'Test Title',
      description: 'Test Description'
    )
  end

  describe '#valid?' do
    subject { @sensor.records.new(value: value) }

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

  describe '.avg_on_day' do
    context 'only records of granularity finest exist' do
      before :each do
        @sensor.records.create(value: 3.0, created_at: DateTime.new(2001,1,1,1,1,1,'+0'))
        @sensor.records.create(value: 7.0, created_at: DateTime.new(2001,1,1,2,2,2,'+0'))
      end

      it 'calculates the average of a day' do
        avg = Record.avg_on_day DateTime.new(2001, 1, 1)
        expect(avg).to eq 5
      end
    end

    context 'records of different days' do
      before :each do
        @sensor.records.create(value: 3.0, created_at: DateTime.new(2001,1,1,1,1,1,'+0'))
        @sensor.records.create(value: 7.0, created_at: DateTime.new(2001,1,2,1,1,1,'+0'))
      end

      it 'only calculates the average for records of the same day' do
        avg = Record.avg_on_day DateTime.new(2001, 1, 1)
        expect(avg).to eq 3
      end
    end

    context 'records of various granularities exist' do
      before :each do
        @sensor.records.create(value: 3.0, created_at: DateTime.new(2001,1,1), granularity: Record.granularities[:daily])
        @sensor.records.create(value: 1.0, created_at: DateTime.new(2001,1,1), granularity: Record.granularities[:montly])
        @sensor.records.create(value: 7.0, created_at: DateTime.new(2001,1,1,2,2,2,'+0'))
      end

      it 'ignores any values other than granularity finest' do
        avg = Record.avg_on_day DateTime.new(2001, 1, 1)
        expect(avg).to eq 7
      end
    end
  end

  describe '.avg_in_month' do
    context 'only records of granularity finest exist' do
      before :each do
        @sensor.records.create(value: 3.0, created_at: DateTime.new(2001,1,1,1,1,1,'+0'))
        @sensor.records.create(value: 7.0, created_at: DateTime.new(2001,1,2,2,2,2,'+0'))
      end

      it 'calculates the average of a day' do
        avg = Record.avg_in_month DateTime.new(2001, 1, 1)
        expect(avg).to eq 5
      end
    end

    context 'records of different months' do
      before :each do
        @sensor.records.create(value: 3.0, created_at: DateTime.new(2001,1,1,1,1,1,'+0'))
        @sensor.records.create(value: 7.0, created_at: DateTime.new(2001,2,1,1,1,1,'+0'))
      end

      it 'only calculates the average for records of the same month' do
        avg = Record.avg_in_month DateTime.new(2001, 1, 1)
        expect(avg).to eq 3
      end
    end

    context 'records of various granularities exist' do
      before :each do
        @sensor.records.create(value: 3.0, created_at: DateTime.new(2001,1,1), granularity: Record.granularities[:daily])
        @sensor.records.create(value: 1.0, created_at: DateTime.new(2001,1,1), granularity: Record.granularities[:montly])
        @sensor.records.create(value: 7.0, created_at: DateTime.new(2001,1,1,2,2,2,'+0'))
      end

      it 'ignores any values other than granularity finest' do
        avg = Record.avg_in_month DateTime.new(2001, 1, 1)
        expect(avg).to eq 7
      end
    end
  end

  describe '.avg_in_year' do
    context 'only records of granularity finest exist' do
      before :each do
        @sensor.records.create(value: 3.0, created_at: DateTime.new(2001,1,1,1,1,1,'+0'))
        @sensor.records.create(value: 7.0, created_at: DateTime.new(2001,1,2,2,2,2,'+0'))
      end

      it 'calculates the average of a day' do
        avg = Record.avg_in_year DateTime.new(2001, 1, 1)
        expect(avg).to eq 5
      end
    end

    context 'records of different years' do
      before :each do
        @sensor.records.create(value: 3.0, created_at: DateTime.new(2001,1,1,1,1,1,'+0'))
        @sensor.records.create(value: 7.0, created_at: DateTime.new(2002,1,1,1,1,1,'+0'))
      end

      it 'only calculates the average for records of the same month' do
        avg = Record.avg_in_year DateTime.new(2001, 1, 1)
        expect(avg).to eq 3
      end
    end

    context 'records of various granularities exist' do
      before :each do
        @sensor.records.create(value: 3.0, created_at: DateTime.new(2001,1,1), granularity: Record.granularities[:daily])
        @sensor.records.create(value: 1.0, created_at: DateTime.new(2001,1,1), granularity: Record.granularities[:montly])
        @sensor.records.create(value: 7.0, created_at: DateTime.new(2001,1,1,2,2,2,'+0'))
      end

      it 'ignores any values other than granularity finest' do
        avg = Record.avg_in_year DateTime.new(2001, 1, 1)
        expect(avg).to eq 7
      end
    end
  end
end
