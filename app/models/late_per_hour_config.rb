class LatePerHourConfig < LatenessConfig
  validates :days_per_assignment, :numericality => true
  validates :frequency, :numericality => true
  validates :max_penalty, :numericality => true
  validates :percent_off, :numericality => true

  def allow_submission?(assn, sub)
    days_late(assn, sub) <= self.days_per_assignment
  end

  def late_penalty(assn, sub)
    penalty = (self.percent_off || 0).to_f * hours_late(assn, sub).to_f
    penalty.clamp(0, self.max_penalty)
  end

  def to_s
    if self.days_per_assignment.nil?
      days_allowed = "unlimited late days"
    else
      days_allowed = pluralize(self.days_per_assignment, "late day")
    end

    "Allow #{days_allowed}, penalizing #{self.percent_off}% each hour up to #{self.max_penalty}%"
  end

  def ==(other)
    if other.instance_of?(LatePerHourConfig)
      self.days_per_assignment == other.days_per_assignment &&
        self.frequency == other.frequency &&
        self.max_penalty == other.max_penalty &&
        self.percent_off == other.percent_off
    else
      false
    end
  end

  #private

  def hours_late(assignment, submission, raw = false)
    return 0 unless raw or late?(assignment, submission)
    due_on = assignment.effective_due_date(submission.user, submission.team)
    sub_on = submission.created_at || DateTime.current
    late_hours = (sub_on.to_time - due_on.to_time) / 1.hour.seconds
    late_hours.ceil
  end
end
