# encoding: utf-8

module DOTIW
  class TimeHash
    TIME_FRACTIONS = [:seconds, :minutes, :hours, :days, :months, :years]

    attr_accessor :distance, :smallest, :largest, :from_time, :to_time, :options

    def initialize(distance, from_time = nil, to_time = nil, options = {})
      self.output     = {}
      self.options    = options
      self.distance   = distance
      self.from_time  = from_time || Time.now
      self.to_time    = to_time   || (self.from_time + self.distance.seconds)
      self.smallest, self.largest = [self.from_time, self.to_time].minmax

      I18n.locale = options[:locale] if options[:locale]

      build_time_hash
    end

    def to_hash
      output
    end

    private
      attr_accessor :options, :output

      def build_time_hash
        if accumulate_on = options.delete(:accumulate_on)
          return build_time_hash if accumulate_on == :years
          TIME_FRACTIONS.index(accumulate_on).downto(0) { |i| self.send("build_#{TIME_FRACTIONS[i]}") }
        else
          while distance > 0
            if distance < 1.minute
              build_seconds
            elsif distance < 1.hour
              build_minutes
            elsif distance < 1.day
              build_hours
            elsif distance < 28.days
              build_days
            else # greater than a month
              build_years_months_days
            end
          end
        end

        output
      end

      def build_seconds
        output[I18n.t(:seconds, :default => "seconds")] = distance.to_i
        self.distance = 0
      end

      def build_minutes
        output[I18n.t(:minutes, :default => "minutes")], self.distance = distance.divmod(1.minute)
      end

      def build_hours
        output[I18n.t(:hours, :default => "hours")], self.distance = distance.divmod(1.hour)
      end

      def build_days
        output[I18n.t(:days, :default => "days")], self.distance = distance.divmod(1.day)
      end

      def build_months
        build_years_months_days

        if (years = output.delete(I18n.t(:years, :default => "years"))) > 0
          output[I18n.t(:months, :default => "months")] += (years * 12)
        end
      end

      def build_years_months_days
        months = (largest.year - smallest.year) * 12 + (largest.month - smallest.month)
        years, months = months.divmod(12)

        days = largest.day - smallest.day

        # Will otherwise incorrectly say one more day if our range goes over a day.
        days -= 1 if largest.hour < smallest.hour

        if days < 0
          # Convert the last month to days and add to total
          months -= 1
          last_month = largest.advance(:months => -1)
          days += Time.days_in_month(last_month.month, last_month.year)
        end

        if months < 0
          # Convert a year to months
          years -= 1
          months += 12
        end

        output[I18n.t(:years,   :default => "years")]   = years
        output[I18n.t(:months,  :default => "months")]  = months
        output[I18n.t(:days,    :default => "days")]    = days

        total_days, self.distance = (from_time - to_time).abs.divmod(1.day)
      end
  end # TimeHash

  class DOTIW
    def distance_of_time_in_words_hash(from_time, to_time, options = {})
      from_time = from_time.to_time if !from_time.is_a?(Time) && from_time.respond_to?(:to_time)
      to_time   = to_time.to_time   if !to_time.is_a?(Time)   && to_time.respond_to?(:to_time)

      TimeHash.new((from_time - to_time).abs, from_time, to_time, options).to_hash
    end

    def distance_of_time(seconds, options = {})
      options[:include_seconds] ||= true
      display_time_in_words DOTIW::TimeHash.new(seconds).to_hash, options
    end

    def distance_of_time_in_words(from_time, to_time, include_seconds = false, options = {})
      options[:include_seconds] = include_seconds
      hash = distance_of_time_in_words_hash(from_time, to_time, options)
      display_time_in_words(hash, options)
    end

    def distance_of_time_in_percent(from_time, current_time, to_time, options = {})
      options[:precision] ||= 0
      distance = to_time - from_time
      result = ((current_time - from_time) / distance) * 100
      number_with_precision(result, options).to_s + "%"
    end

    def time_ago_in_words(from_time, include_seconds = false, options = {})
      distance_of_time_in_words(from_time, Time.now, include_seconds, options)
    end

    private
      def display_time_in_words(hash, options = {})
        options = {
          :include_seconds => false
        }.update(options).symbolize_keys

        I18n.locale = options[:locale] if options[:locale]

        time_measurements = ActiveSupport::OrderedHash.new
        time_measurements[:years]   = I18n.t(:years,   :default => "years")
        time_measurements[:months]  = I18n.t(:months,  :default => "months")
        time_measurements[:weeks]   = I18n.t(:weeks,   :default => "weeks")
        time_measurements[:days]    = I18n.t(:days,    :default => "days")
        time_measurements[:hours]   = I18n.t(:hours,   :default => "hours")
        time_measurements[:minutes] = I18n.t(:minutes, :default => "minutes")
        time_measurements[:seconds] = I18n.t(:seconds, :default => "seconds")

        hash.delete(time_measurements[:seconds]) if !options.delete(:include_seconds) && hash[time_measurements[:minutes]]

        # Remove all the values that are nil or excluded. Keep the required ones.
        time_measurements.delete_if do |measure, key|
          hash[key].nil? || hash[key].zero? || (!options[:except].nil? && options[:except].include?(key)) ||
            (options[:only] && !options[:only].include?(key))
        end

        options.delete(:except)
        options.delete(:only)

        output = []

        time_measurements = Hash[*time_measurements.first] if options.delete(:highest_measure_only)

        time_measurements.each do |measure, key|
          name = options[:singularize] == :always || hash[key].between?(-1, 1) ? key.singularize : key
          output += ["#{hash[key]} #{name}"]
        end

        options.delete(:singularize)

        # maybe only grab the first few values
        if options[:precision]
          output = output[0...options[:precision]]
          options.delete(:precision)
        end

        output.to_sentence(options)
      end
  end # DateHelper
end # DOTIW
