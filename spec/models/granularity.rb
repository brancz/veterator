RSpec.describe Granularity do
  describe '.select_by_time_range' do
    context 'from and to are seconds apart' do
      it 'return the finest granularity' do
        granularity = Granularity.select_by_time_range(5.seconds.ago, Time.now)
        expect(granularity).to be :finest
      end
    end

    context 'from and to are days apart' do
      it 'return the daily granularity' do
        granularity = Granularity.select_by_time_range(5.days.ago, Time.now)
        expect(granularity).to be :daily
      end
    end

    context 'from and to are months apart' do
      it 'return the monthly granularity' do
        granularity = Granularity.select_by_time_range(5.months.ago, Time.now)
        expect(granularity).to be :monthly
      end
    end

    context 'from and to are years apart' do
      it 'return the yearly granularity' do
        granularity = Granularity.select_by_time_range(5.years.ago, Time.now)
        expect(granularity).to be :yearly
      end
    end
  end
end
