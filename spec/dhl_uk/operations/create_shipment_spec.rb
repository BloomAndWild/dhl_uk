# frozen_string_literal: true

RSpec.describe DhlUk::Operations::CreateShipment do
  subject { described_class.new(payload: payload) }

  before { configure_client }

  describe '#execute' do
    let(:payload) do
      {
        "username": ENV['DHL_UK_USERNAME'],
        "authenticationToken": "7312A80B-3D2C-48FD-B051-64FD9714801F",
        "accountNumber": ENV['DHL_UK_ACCOUNT'],
        "collectionInfo": {
          "collectionJobNumber": "",
          "collectionDate": "2020-09-30"
        },
        "delivery": {
          "localContactName": "Mr John Doe",
          "localContactNumber": 7691347758,
          "contactNumberType": "mobile",
          "localContactEmail": "JohnDoe@webmail.com",
          "deliveryAddresses": [
            {
              "address1": "56 Far Gosford Street",
              "address2": "",
              "address3": "Ball Hill",
              "postalTown": "Coventry",
              "county": "",
              "postcode": "CV1 5DZ",
              "countryCode": "GBR",
              "addressType": "doorstep",
              "servicePointID": "",
              "specialInstructions": "",
              "secureLocation": ""
            }
          ]
        },
        "serviceKey": 220,
        "items": 1,
        "totalWeight": 1,
        "customerReference": "Delivery#id",
        "parcels": [
          {
            "length": 58,
            "width": 22,
            "height": 15
          }
        ],
        "recipient": {
          "contactName": "Mr John Doe",
          "contactEmail": "JohnDoe@webmail.com",
          "contactNumber": "02046768678",
          "recipientAddress": {
            "businessName": nil,
            "address1": "Apartment 1a",
            "address2": "Tall Towers",
            "address3": "Ball Hill",
            "postalTown": "Coventry",
            "county": nil,
            "postcode": "CV1 5AA",
            "countryCode": "GBR",
            "addressType": "residential"
          },
          "preDeliveryNotificationType": "none"
        },
        "labelFormat": "PDF200dpi6x4"
      }
    end

    context 'on successful request' do
      let(:identifiers) do
        {
          identifierType: "consignmentNumber",
          identifierValue: "41150120000007"
        }
      end

      it 'returns the shipment identifier and label(s)' do
        VCR.use_cassette('operations/create_shipment_success') do
          response = subject.execute

          expect(response[:identifiers][0]).to eq(identifiers)
          expect(response[:labels][0]).to be_a(String)
        end
      end
    end

    context 'on unsuccessful request' do
      context 'with incorrect api_key' do
        before { configure_client(api_key: 'foo_bar') }

        it 'raises an exception' do
          VCR.use_cassette('operations/create_shipment_api_key_failure') do
            expect { subject.execute }.to raise_error(DhlUk::Errors::ResponseError) do |err|
              expect(err.status).to eq(401)
              expect(err.reason).to eq('Unauthorized')
              expect(err.body).not_to be_empty
            end
          end
        end
      end

      context 'without a valid auth token' do
        before { payload[:authenticationToken] = "not-a-valid-token" }

        it 'raises an exception' do
          VCR.use_cassette('operations/create_shipment_auth_token_failure') do
            expect { subject.execute }.to raise_error(DhlUk::Errors::ResponseError) do |err|
              expect(err.status).to eq(401)
              expect(err.reason).to eq("com.wm.net.NetException: [ISC.0064.9314] Authorization Required: Unauthorized")
              expect(err.body).to be_empty
            end
          end
        end
      end

      context 'without a postcode' do
        before { payload[:delivery][:deliveryAddresses][0][:postcode] = nil }

        let(:error_message) { ["The Postcode field is required."] }

        it 'raises an exception' do
          VCR.use_cassette('operations/create_shipment_postcode_failure') do
            expect { subject.execute }.to raise_error(DhlUk::Errors::ResponseError) do |err|
              expect(err.status).to eq(400)
              expect(err.reason).to eq('Bad Request')
              expect(err.body[:Errors].values).to include(error_message)
            end
          end
        end
      end

      context 'without a collectionDate' do
        before { payload[:collectionInfo][:collectionDate] = nil }

        let(:error_message) { ["Either Collection Job Number or Date must be supplied"] }

        it 'raises an exception' do
          VCR.use_cassette('operations/create_shipment_collection_date_failure') do
            expect { subject.execute }.to raise_error(DhlUk::Errors::ResponseError) do |err|
              expect(err.status).to eq(400)
              expect(err.reason).to eq('Bad Request')
              expect(err.body[:Errors].values).to include(error_message)
            end
          end
        end
      end
    end
  end
end
