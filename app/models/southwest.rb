class Southwest

  def initialize
    clear_log
    @agent = Mechanize.new
    @agent.user_agent_alias = "Mac Mozilla"
    @agent.log = Logger.new "mech.log"

    # @agent.page.links
    # @agent.page.search("booking-form--check-in-tab")[1]

  end
  # confirmation_number="9ABY8I", first_name="Piper", last_name="Hewitt"
  # def check_in(confirmation_number="", first_name="", last_name="")
  def check_in(confirmation_number="9ABY8I", first_name="Piper", last_name="Hewitt")
    page = @agent.get("https://www.southwest.com/flight/retrieveCheckinDoc.html?int=HOME-BOOKING-WIDGET-AIR-CHECKIN#js-booking-panel-check-in")
    check_in_form = page.form_with :name => "retrieveItinerary"
    check_in_form.field_with(:name => 'confirmationNumber').value = "#{confirmation_number}"
    check_in_form.field_with(:name => 'firstName').value = "#{first_name}"
    check_in_form.field_with(:name => 'lastName').value = "#{last_name}"
    check_in_form.submit
    check_response
  end

  def check_response
    sleep 2
    response_page = @agent.page
    errors = response_page.search("#errors")
    if errors.present?
      if errors.first.text.include?("The request to check in and print your Boarding Pass is more than 24 hours prior to your scheduled ")
        puts "not time yet"
        resubmit_form(response_page)
      else
        errors.each do |error|
          puts "Error: #{error.text.strip}"
        end
      end
    else
      # Submit Next page!
    end

  end

  def resubmit_form(page)
    sleep 2
    response_page = @agent.page
    check_in_form = page.form_with :name => "retrieveItinerary"
    check_in_form.submit
    puts "resubmitted form"
    sleep 2
  end


  def sleeper(num)
    sleep(rand(num))
  end

  #clears log file
  def clear_log
    File.truncate('mech.log', 0)
  end

end
