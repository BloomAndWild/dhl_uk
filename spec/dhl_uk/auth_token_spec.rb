# frozen_string_literal: true

RSpec.describe DHLUk::AuthToken do
  describe '#token' do
    context 'on successful request' do
      before { configure_client }

      it 'returns the token' do
        VCR.use_cassette('auth_token/success') do
          expect(subject.token).to eq('3593A9F0-1E3A-41BD-8366-B72E9540099B')
        end
      end
    end

    context 'on unsuccessful request' do
      context 'with incorrect api_key' do
        before { configure_client(api_key: 'foo_bar') }

        it 'raises an exception' do
          VCR.use_cassette('auth_token/wrong_api_key') do
            expect { subject.token }.to raise_error(DHLUk::Errors::AuthTokenError) do |err|
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
            expect { subject.token }.to raise_error(DHLUk::Errors::AuthTokenError) do |err|
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
            expect { subject.token }.to raise_error(DHLUk::Errors::AuthTokenError) do |err|
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
