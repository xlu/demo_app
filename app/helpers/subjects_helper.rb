module SubjectsHelper
  def friendly_subject_age(subject, tz_offset = nil)
    begin
      subject_birth_date = Time.zone.local(subject.birth_year.to_i, subject.birth_month.to_i, subject.birth_day.to_i)

      if tz_offset
        zone = ActiveSupport::TimeZone[tz_offset.to_i]
      else
        zone = ActiveSupport::TimeZone.new('Pacific Time (US & Canada)')
      end
      today = zone.today

      if subject_birth_date < today
        return DOTIW::DOTIW.new.distance_of_time_in_words(subject_birth_date, today, true, {:only => ["years", "months", "days"]}) + " old"
      else
        return "Not yet born"
      end
    rescue
      return nil
    end
  end

end
