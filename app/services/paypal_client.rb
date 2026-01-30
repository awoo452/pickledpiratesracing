require "net/http"
require "json"

class PaypalClient
  class Error < StandardError; end

  def initialize
    @client_id = ENV["PAYPAL_CLIENT_ID"]
    @secret = ENV["PAYPAL_SECRET"]
    raise Error, "Missing PAYPAL_CLIENT_ID" if @client_id.blank?
    raise Error, "Missing PAYPAL_SECRET" if @secret.blank?

    env = ENV.fetch("PAYPAL_ENV", "sandbox")
    @base_url = env == "live" ? "https://api-m.paypal.com" : "https://api-m.sandbox.paypal.com"
  end

  def create_order(amount:, currency: "USD", description: nil)
    body = {
      intent: "CAPTURE",
      purchase_units: [
        {
          amount: {
            currency_code: currency,
            value: amount
          },
          description: description
        }
      ]
    }

    post_json("/v2/checkout/orders", body)
  end

  def capture_order(order_id)
    post_json("/v2/checkout/orders/#{order_id}/capture", {})
  end

  private

  def access_token
    uri = URI("#{@base_url}/v1/oauth2/token")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth(@client_id, @secret)
    request["Accept"] = "application/json"
    request["Content-Type"] = "application/x-www-form-urlencoded"
    request.set_form_data({ "grant_type" => "client_credentials" })

    response = perform_request(uri, request)
    data = JSON.parse(response.body)
    token = data["access_token"]
    raise Error, "PayPal auth failed" if token.blank?

    token
  end

  def post_json(path, payload)
    uri = URI("#{@base_url}#{path}")
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{access_token}"
    request["Content-Type"] = "application/json"
    request.body = payload.to_json

    response = perform_request(uri, request)
    JSON.parse(response.body)
  end

  def perform_request(uri, request)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    response = http.request(request)

    return response if response.is_a?(Net::HTTPSuccess)

    raise Error, "PayPal error #{response.code}: #{response.body}"
  end
end
