defmodule Gts.AES do

  # Encrypts each plaintext with a different, random IV. This is much more
  # secure than reusing the same IV, and is highly recommended.
  def encrypt(plaintext) do
    iv    = :crypto.strong_rand_bytes(16) # Random IVs for each encryption
    state = :crypto.stream_init(:aes_ctr, key, iv)

    {_state, ciphertext} = :crypto.stream_encrypt(state, to_string(plaintext))
    iv <> ciphertext # Prepend IV to ciphertext, for easier decryption
  end

  def decrypt(ciphertext) do
    # Split the IV that was used off the front of the binary. It's the first
    # 16 bytes.
    <<iv::binary-16, ciphertext::binary>> = ciphertext
    state = :crypto.stream_init(:aes_ctr, key, iv)

    {_state, plaintext} = :crypto.stream_decrypt(state, ciphertext)
    plaintext
  end

  # Convenience function to get the application's configuration key.
  defp key do
    Application.get_env(:gts, Gts.AES)[:key]
  end
end
