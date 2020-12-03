class CasaCaseDecorator < Draper::Decorator
  delegate_all

  def status
    object.active ? "Active" : "Inactive"
  end

  def transition_aged_youth_icon
    object.transition_aged_youth ? "Yes #{transition_aged_youth_only_icon}" : "No #{transition_aged_youth_only_icon}"
  end

  def transition_aged_youth_only_icon
    if object.transition_aged_youth
      return "🦋" unless object.birth_month_year_youth
      first_month = object.birth_month_year_youth.month ==  Time.now.month
      first_year =  object.birth_month_year_youth.year == Time.now.year - 14
      first_month && first_year ?  "🐛🦋" : "🦋"
    else
      "🐛"
    end
  end

  def court_report_submission
    object.court_report_status.humanize
  end

  def court_report_submitted_date
    object.court_report_submitted_at&.strftime(DateFormat::FULL)
  end

  def case_contacts_ordered_by_occurred_at
    object.case_contacts.sort_by(&:occurred_at)
  end

  def case_contacts_latest
    object.case_contacts.max_by(&:occurred_at)
  end

  def successful_contacts_this_week
    this_week = Date.today - 7.days..Date.today
    object.case_contacts.where(occurred_at: this_week).where(contact_made: true).count
  end

  def unsuccessful_contacts_this_week
    this_week = Date.today - 7.days..Date.today
    object.case_contacts.where(occurred_at: this_week).where(contact_made: false).count
  end

  def court_report_select_option
    [
      "#{object.case_number} - #{object.has_transitioned? ? "transition" : "non-transition"}",
      object.case_number,
      {"data-transitioned": object.has_transitioned?}
    ]
  end

  def inactive_class
    !object.active ? "table-secondary" : ""
  end

  def formatted_updated_at
    object.updated_at.strftime(DateFormat::MM_DD_YYYY)
  end
end
