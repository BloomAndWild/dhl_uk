# frozen_string_literal: true

RSpec.describe DhlUk::Operations::CreateShipment do
  subject { described_class.new(payload: payload) }

  describe '#execute' do

    let(:payload) do
      {
        "username": "dev+dhluk@bloomandwild.com",
        "authenticationToken": "7312A80B-3D2C-48FD-B051-64FD9714801F",
        "accountNumber": "K118696",
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
      before { configure_client }

      let(:identifiers) do
        {
          identifierType: "consignmentNumber",
          identifierValue: "41150120000005"
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
          VCR.use_cassette('auth_token/wrong_api_key') do
            expect { subject.token }.to raise_error(DhlUk::Errors::AuthTokenError) do |err|
              expect(err.status).to eq(401)
              expect(err.reason).to eq('Unauthorized')
              expect(err.body).not_to be_empty
            end
          end
        end
      end

      context 'with incorrect username' do
        before { configure_client(username: 'foo_bar') }

        it 'raises an exception' do
          VCR.use_cassette('auth_token/wrong_username') do
            expect { subject.token }.to raise_error(DhlUk::Errors::AuthTokenError) do |err|
              expect(err.status).to eq(401)
              expect(err.reason).to match('Unauthorized')
              expect(err.body).to be_empty
            end
          end
        end
      end

      context 'with incorrect password' do
        before { configure_client(password: 'foo_bar') }

        it 'raises an exception' do
          VCR.use_cassette('auth_token/wrong_password') do
            expect { subject.token }.to raise_error(DhlUk::Errors::AuthTokenError) do |err|
              expect(err.status).to eq(401)
              expect(err.reason).to match('Unauthorized')
              expect(err.body).to be_empty
            end
          end
        end
      end
    end
  end
end
