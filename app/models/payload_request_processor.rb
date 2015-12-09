class PayloadRequestProcessor

  def self.json_parse?(params)
    (params[:payload] = JSON.parse(params[:payload])) if !missing_payload?(params)
    params
  end

  def self.missing_payload?(params)
    params[:payload] == nil
  end

  def self.already_received?(params)
    # binding.pry
    Payload.all.any? {|pay| pay.requestedAt == params[:payload]["requestedAt"]}
  end

  def self.not_registered?(params)
    # binding.pry
    Application.all.none? {|app| app.identifier == params["IDENTIFIER"]}
  end

  def self.create_payload(params)
    payload = Payload.create(requestedAt: params[:payload]["requestedAt"], respondedIn: params[:payload]["respondedIn"])
    application = Application.all.find { |app| app[:identifier] == params["IDENTIFIER"] }
    application.payloads << payload
  end

  def self.process_request(params)
    params = json_parse?(params)
      if missing_payload?(params)
        {status: 400, body: "Missing Payload - 400 Bad Request"}
      elsif already_received?(params)
        {status: 403, body: "Already Received Request - 403 Forbidden"}
      elsif not_registered?(params)
        {status: 403, body: "Not Registered - 403 Forbidden"}
      else
        create_payload(params)
        {status: 200, body: "200 OK"}
      end
  end

end
