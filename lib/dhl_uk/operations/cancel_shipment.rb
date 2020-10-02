# frozen_string_literal: true

module DhlUk
  module Operations
    class CancelShipment
      TARGET_NAMESPACE = "http://www.UKMail.com/Services/Contracts/ServiceContracts"
      SOAP_ACTION = "http://www.UKMail.com/Services/IUKMConsignmentService/CancelConsignment"

      def initialize payload:
        @payload = payload
      end

      def execute
        response = savon_client.call(:cancel_consignment, xml: xml_payload)

        response.to_hash
      rescue => err
        raise DhlUk::Errors::CancelRequestError.new(err)
      end

      private

      attr_reader :payload

      def http_method
        :post
      end

      def endpoint
        config.cancel_url
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
          'SOAPAction' => SOAP_ACTION,
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
    end
  end
end
