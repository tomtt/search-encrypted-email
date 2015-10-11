require 'gpgme'

class GPG
  def self.decrypt(encrypted_content)
    @@instance ||= GPG.new
    @@instance.decrypt(encrypted_content)
  end

  def decrypt(encrypted_content)
    encrypted_data = GPGME::Data.new(encrypted_content)
    decrypted = @ctx.decrypt encrypted_data
    decrypted.seek(0)
    decrypted.read
  end

  def passfunc(obj, uid_hint, passphrase_info, prev_was_bad, fd)
    io = IO.for_fd(fd, 'w')
    io.puts "PASSPHRASE"
    io.flush
  end

  protected

  def initialize
    @ctx = GPGME::Ctx.new :passphrase_callback => method(:passfunc)
  end
end

