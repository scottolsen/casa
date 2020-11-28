module CasaCaseHelper
  def successful_contacts_this_week1(casa_case)
    this_week = Date.today - 7.days..Date.today
    casa_case.case_contacts.where(occurred_at: this_week).where(contact_made: true).count
  end

  def unsuccessful_contacts_this_week1(casa_case)
    this_week = Date.today - 7.days..Date.today
    casa_case.case_contacts.where(occurred_at: this_week).where(contact_made: false).count
  end
end