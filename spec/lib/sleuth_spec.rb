require 'spec_helper'

describe Sleuth do
  describe '#entry_qualifies' do
    let(:sleuth) { Sleuth.new('needle') }

    it "does not qualify for empty result" do
      expect(sleuth.entry_qualifies?({})).to be_falsy
    end

    it "does not qualify for result with no matching elements" do
      entry = {
        "subject" => "nothing in this haystack",
        "body" => "also nothing in here",
        "author" => "nope, nothing"
      }
      expect(sleuth.entry_qualifies?(entry)).to be_falsy
    end

    it "qualifies if the subject matches" do
      expect(sleuth.entry_qualifies?({ "subject" => "there is a needle in here" })).to be_truthy
    end

    it "qualifies if the author matches" do
      expect(sleuth.entry_qualifies?({ "author" => "there is a needle in here" })).to be_truthy
    end

    it "qualifies if the body matches" do
      expect(sleuth.entry_qualifies?({ "body" => "there is a needle in here" })).to be_truthy
    end

    it "qualifies if decrypted body matches" do
      encrypted_body = <<EOT
-----BEGIN PGP MESSAGE-----

hQEMA7fV8Ad9jBxRAQf+LxKwv7bzYhng4xArxLT1dM7MyuJxK8YOqbgQ4LVxR5w9
5tMIWT3HHwErosw2zcZ3IEzsXOfzvupiVPnDwDNZ2y2cFPcgYVMm7N4aj1OPAoae
FzzWn7ly21t4ewELS920Y6etE3sXuREmA20qn5d4dKsIBHzaYZpTtxQtWzEIOePW
/rr4rCsMkAyOcGROIECrfn7d+mTwuP3vQw3XJS/JJ2by2lR6nW5m5kf2eRVM9NEI
n116EPhGIUXK1M+c3CsQIBycN3yMivJfdZlIcghgRkD3mORKxMK8sUZ14Cg1hhxl
yB8DTKAOfWPAiDbkzibcv4t3FOQ7mKsGqhkcllulsNJWAR4fRR1CEx/t15cMv4ex
TYy07n5Lm+OA22AbRf+E9X0cd0lhjlncBJDFXlODzB0L/UbZRKkVyh96OkJcSH4N
ekfxHnvNb+PJ9J4DekaV/Buyf10r6Fw=
=sCXg
-----END PGP MESSAGE-----
EOT
      decrypted_body = "This needle is hidden"
      allow(GPG).
        to receive(:decrypt).
        with(encrypted_body).
        and_return(decrypted_body)
      expect(sleuth.entry_qualifies?({ "body" => encrypted_body })).to be_truthy
    end
  end
end
