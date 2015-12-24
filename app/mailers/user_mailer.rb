class UserMailer < BaseMandrillMailer

  def user_email(user_id)
    user = User.find(user_id)
    subject = 'Thank you for choosing Greenbelt Greens service!'
    merge_vars = {
      'FIRST_NAME' => user.first_name,
      'LAST_NAME' => user.last_name,
      'FIRST_DELIVERY_DATE' => user.first_delivery_date,
      'DELIVERY_WINDOW' => user.weekend_delivery_range,
      'NUMBER_OF_MEALS_PER_WEEK' => user.number_of_meals,
      'TOTAL_AMOUNT' => user.total_amount,
      'USER_REFERRAL_CODE' => user.referral_code.secret_code
    }
    body = mandrill_template('user_email_template', merge_vars)

    send_mail(user.email, subject, body)
  end

  def admin_email(user_id)
    user = User.find(user_id)
    subject = "[Greenbelt Greens] new user in system: #{user.email}"
    merge_vars = {
      'FIRST_NAME' => user.first_name,
      'LAST_NAME' => user.last_name,
      'USER_EMAIL' => user.email,
      'FIRST_DELIVERY_DATE' => user.first_delivery_date,
      'DELIVERY_WINDOW' => user.weekend_delivery_range,
      'NUMBER_OF_MEALS_PER_WEEK' => user.number_of_meals,
      'TOTAL_AMOUNT' => user.total_amount,
      'ADDRESS' => user.address1,
      'ADDRESS_2' => user.address2,
      'ADDRESS_INSTRUCTIONS' => user.delivery_instructions,
      'MOBILE' => user.phone,
      'LINK_TO_ADMIN_PAGE' => "http://greenbeltgreens-stage.herokuapp.com/admin/users/#{user.id}/edit",
      'LINK_TO_CUSTOMER_PAGE_ON_STRIPE' => "https://dashboard.stripe.com/test/customers/#{user.customer_id}"
    }
    body = mandrill_template('admin_email_template', merge_vars)

    send_mail(ADMIN_EMAIL, subject, body)
  end
end
