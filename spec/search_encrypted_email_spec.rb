require 'spec_helper'

describe SearchEncryptedEmail do
  it "knows its root" do
    expect(SearchEncryptedEmail.root).to eq Pathname.new(File.absolute_path("."))
  end
end
