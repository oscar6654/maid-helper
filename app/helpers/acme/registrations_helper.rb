module Acme::RegistrationsHelper

  def mobile_verification_button
    return '' unless current_user.needs_mobile_number_verifying?
    html = <<-HTML
      <h3>Verify Mobile Number</h3>
      #{form_tag(verifications_path, method: "post")}
      #{button_tag('Send verification code', type: "submit", class: "col s12 btn btn-large waves-effect indigo")}
      <br/>
      <br/>
      <br/>
      <br/>
      </form>
    HTML
    html.html_safe
  end

  def change_mobile_number
    return '' unless current_user.resend_code?
    html = <<-HTML
      #{form_tag(delete_number_verifications_path, method: "patch")}
      #{button_tag('Change Phone Number', type: "submit", class: "btn-flat")}
      <br/>
      <br/>
      </form>
    HTML
    html.html_safe
  end
  def verify_mobile_number_form
    return '' if current_user.verification_code.blank?
    p current_user.verification_code.blank?
    html = <<-HTML
      <h3>Enter Verification Code</h3>
      #{form_tag(verifications_path, method: "patch")}
      #{text_field_tag('verification_code')}
      #{button_tag('Submit', type: "submit", class: "col s12 btn btn-large waves-effect indigo")}
      <br/>
      <br/>
      <br/>
      <br/>
      </form>
    HTML
    html.html_safe
  end
  def delete_number_form

  end
  def mobile_number_form
    return '' unless current_user.mobile_number_filled?
    html = <<-HTML
      <div class='row'>
        <div class='col s12'>
          <h4 class="indigo-text">PH Mobile Number(ex. 09181234567)</h4>
        </div>
      </div>
      #{form_tag(mobile_verifications_path, method: "patch")}
      #{number_field_tag('verification_code')}
      <center>
      #{button_tag('Add Mobile Number', type: "submit", class: "col s12 btn btn-large waves-effect indigo")}
      </center>
      <br/>
      <br/>
      <br/>
      <br/>
      </form>
    HTML
    html.html_safe
  end


end
