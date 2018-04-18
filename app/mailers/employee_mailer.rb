class EmployeeMailer < ApplicationMailer
  default from: "registration@example.com"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.employee_mailer.registration.subject
  #
  def registration_email(employee, password)
    @password = password
    @employee = employee

    mail(to: @employee.email, subject: "Registration email")
  end
end
