# frozen_string_literal: true

module DhlUk
  module Operations
    class CancelShipment
      TARGET_NAMESPACE = "http://www.UKMail.com/Services/Contracts/ServiceContracts"
      ENDPOINT = "/Services/UKMConsignmentServices/UKMConsignmentService.svc"

      def initialize payload:
        @payload = payload
      end

      def execute
        response = savon_client.call(:cancel_consignment, xml: xml_payload)

        return response.to_hash # handle or if response.success?
      #   return handle_response(response) if response.success?
      #
      #   handle_error_response(response)
      # rescue Savon::SOAPFault => e
      #   raise Errors::SoapResponseError.new(xml: e.xml, error_code: e.http.code)
      end

      private

      attr_reader :payload

      def http_method
        :post
      end

      def endpoint
        config.cancel_url + ENDPOINT
      end

      def auth_token
        payload[:authentication_token]
      end

      def consignment_number
        payload[:consignment_number]
      end

      def xml_payload
        <<-XML
        <soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:ser='http://www.UKMail.com/Services/Contracts/ServiceContracts' xmlns:dat='http://www.UKMail.com/Services/Contracts/DataContracts'>
        <soapenv:Header/>
        <soapenv:Body>
        <ser:CancelConsignment>
        <ser:request>
        <dat:AuthenticationToken>#{auth_token}</dat:AuthenticationToken>
        <dat:Username>#{config.username}</dat:Username>
        <dat:ConsignmentNumber>#{consignment_number}</dat:ConsignmentNumber>
        </ser:request>
        </ser:CancelConsignment>
        </soapenv:Body>
        </soapenv:Envelope>
        XML
      end

      def headers
        {
          'SOAPAction' => 'http://www.UKMail.com/Services/IUKMConsignmentService/CancelConsignment',
          'context-type' => 'text/xml; charset=utf-8'
        }
      end

      def wsdl
        config.cancel_wsdl
      end

      def savon_client
        Savon.client(
          wsdl: wsdl,
          endpoint: endpoint,
          namespace: TARGET_NAMESPACE,
        )
      end

      def config
        Client.config
      end

      def handle_response response_hash
        cancel_consignment_result = response_hash[:cancel_consignment_response][:cancel_consignment_result]

        return cancel_consignment_result if cancel_consignment_result[:result] == "Successful"

        raise Errors::ResponseError(cancel_consignment_result, payload)
      end

      def handle_error_response response
        binding.pry
        raise Errors::SoapResponseError(response, payload)
      end
    end
  end
end
