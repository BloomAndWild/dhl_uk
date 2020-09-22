# frozen_string_literal: true

RSpec.describe DhlUk::Config do
  it { is_expected.to respond_to(:api_key, :api_key=) }
  it { is_expected.to respond_to(:username, :username=) }
  it { is_expected.to respond_to(:password, :password=) }
  it { is_expected.to respond_to(:logger, :logger=) }
end
