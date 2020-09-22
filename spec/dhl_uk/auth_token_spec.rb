# frozen_string_literal: true

RSpec.describe DhlUk::AuthToken do
  describe '#token' do
    context 'on successful request' do
      before { configure_client }

      it 'returns the token' do
        VCR.use_cassette('auth_token/success') do
          expect(subject.token).to eq('BB6C8B30-59F3-4981-BF0E-570686621091')
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
              expect(err.body).to be_empty
            end
          end
        end
      end
    end
  end
end
