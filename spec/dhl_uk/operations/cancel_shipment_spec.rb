# frozen_string_literal: true

RSpec.describe DhlUk::Operations::CancelShipment do
  subject { described_class.new(payload: payload) }

  before { configure_client }

  describe '#execute' do
    let(:payload) do
      {
        "consignment_number": "41150120000017",
        "authentication_token": "0936E549-2DBB-4096-B52B-535C156A002C"
      }
    end

    context 'on successful request' do
      let(:xml_response) do
#         <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
#         <s:Body>
#         <CancelConsignmentResponse xmlns="http://www.UKMail.com/Services/Contracts/ServiceContracts">
#         <CancelConsignmentResult xmlns:a="http://www.UKMail.com/Services/Contracts/DataContracts" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
#         <a:Errors/>
#         <a:Result>Successful</a:Result>
#                 <a:Warnings/>
#         </CancelConsignmentResult>
#         </CancelConsignmentResponse>
#         </s:Body>
# </s:Envelope>
      end

      it 'returns the shipment identifier and label(s)' do
        VCR.use_cassette('operations/cancel_shipment_success') do
          response = subject.execute

          expect(response[:cancel_consignment_response][:cancel_consignment_result][:result])
            .to eq("Successful")
        end
      end
    end
  end
end
