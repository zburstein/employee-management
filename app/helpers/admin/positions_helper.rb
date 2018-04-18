module Admin::PositionsHelper
  def radio_group(legend, radio_buttons)
    final = ""
    content_tag("fieldset", class: "form-group") do
      final <<"<legend>#{legend}</legend>"
      radio_buttons.each{|button| final << "<div class='form-check'><label class='form-check-label'>#{button}</label></div>"}
      final.html_safe

    end
  end
end
