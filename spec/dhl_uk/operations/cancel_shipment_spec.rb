# frozen_string_literal: true

RSpec.describe DHLUk::Operations::CancelShipment do
  subject { described_class.new(payload: payload) }

  before { configure_client }

  let(:cancel_response) do
    {
      cancel_consignment_response: {
        cancel_consignment_result: {
          errors: nil,
          result: "Successful",
          warnings: nil,
          "@xmlns:a": "http://www.UKMail.com/Services/Contracts/DataContracts",
          "@xmlns:i": "http://www.w3.org/2001/XMLSchema-instance"
        },
        "@xmlns": "http://www.UKMail.com/Services/Contracts/ServiceContracts"
      }
    }
  end

  describe '#execute' do
    let(:payload) do
      {
        "consignment_number": "41150120000017",
        "authentication_token": "0936E549-2DBB-4096-B52B-535C156A002C"
      }
    end

    context 'success' do
      let(:success_response) { cancel_response }

      it 'succeeds' do
        VCR.use_cassette('operations/cancel_shipment_success') do
          response = subject.execute

          expect(response).to eq(success_response)
          expect(response[:cancel_consignment_response][:cancel_consignment_result][:result]).to eq("Successful")
        end
      end
    end

    context 'failure' do
      let(:failure_response) do
        cancel_response.deep_merge(
          cancel_consignment_response: {
            cancel_consignment_result: {
              errors: {
                ukm_web_error: {
                  code: "8193",
                  description: "Validation failed. Consignment is invalid because it has already been cancelled."
                }
              },
              result: "Failed",
            }
          }
        )
      end

      context 'when the consignment is already cancelled' do
        it 'fails' do
          VCR.use_cassette('operations/cancel_shipment_failure_already_cancelled') do
            response = subject.execute

            expect(response).to eq(failure_response)
            expect(response[:cancel_consignment_response][:cancel_consignment_result][:result]).to eq("Failed")
            expect(response[:cancel_consignment_response][:cancel_consignment_result][:errors][:ukm_web_error][:code])
              .to eq("8193")
            expect(response[:cancel_consignment_response][:cancel_consignment_result][:errors][:ukm_web_error][:description])
              .to eq("Validation failed. Consignment is invalid because it has already been cancelled.")
          end
        end
      end

      context 'when the consignment date is in the past' do
        let(:failure_date_response) do
          failure_response.deep_merge(
            cancel_consignment_response: {
              cancel_consignment_result: {
                errors: {
                  ukm_web_error: {
                    description: "Validation failed. Consignment is invalid because it may not be cancelled after it's collection date."
                  }
                }
              }
            }
          )
        end

        it 'fails' do
          payload.merge!("consignment_number": "41150120000012")

          VCR.use_cassette('operations/cancel_shipment_failure_date_has_passed') do
            response = subject.execute

            expect(response).to eq(failure_date_response)
            expect(response[:cancel_consignment_response][:cancel_consignment_result][:result]).to eq("Failed")
            expect(response[:cancel_consignment_response][:cancel_consignment_result][:errors][:ukm_web_error][:code])
              .to eq("8193")
            expect(response[:cancel_consignment_response][:cancel_consignment_result][:errors][:ukm_web_error][:description])
              .to eq("Validation failed. Consignment is invalid because it may not be cancelled after it's collection date.")
          end
        end
      end

      context 'when authentication fails' do
        let(:failure_auth_response) do
          failure_response.deep_merge(
            cancel_consignment_response: {
              cancel_consignment_result: {
                errors: {
                  ukm_web_error: {
                    code: "16384",
                    description: "Data access failed."
                  }
                }
              }
            }
          )
        end

        it 'fails' do
          payload.merge!("authentication_token": "xxx6E549-2DBB-4096-B52B-535C156A002C")

          VCR.use_cassette('operations/cancel_shipment_failure_authentication') do
            response = subject.execute

            expect(response).to eq(failure_auth_response)
            expect(response[:cancel_consignment_response][:cancel_consignment_result][:result]).to eq("Failed")
            expect(response[:cancel_consignment_response][:cancel_consignment_result][:errors][:ukm_web_error][:code])
              .to eq("16384")
            expect(response[:cancel_consignment_response][:cancel_consignment_result][:errors][:ukm_web_error][:description])
              .to eq("Data access failed.")
          end
        end
      end

      context 'when there is an unexpected error' do
        before { configure_client(cancel_url: 'https://qaX-api.ukmail.com') }

        it 'raises a error' do
          VCR.use_cassette('operations/cancel_shipment_savon_config_error') do
            expect { subject.execute }.to raise_error(DHLUk::Errors::CancelRequestError)
          end
        end
      end
    end
  end
end
