defmodule SeedGenerator do
  @moduledoc """
  SeedGenerator is a simple implementation of PBKDF2.

  It can be used to derive a number of keys for various purposes from a given
  secret. This lets applications have a single secure secret, but avoid reusing
  that key in multiple incompatible contexts.
  """

  use Bitwise
  @max_length bsl(1, 32) - 1

  @doc """
  Returns a derived key suitable for use.

  The first parameter to the PBKDF2 key-stretching function is the mnemonic phrase.

  The second parameter to the PBKDF2 key-stretching function is a salt.
  The salt is composed of the string constant "mnemonic" concatenated with an optional user-supplied passphrase string.

  The third parameter to the PBKDF2 key-stretching function is the options
  using 2048 rounds of hashing with the HMAC-SHA512 algorithm,
  producing a 512-bit value as its final output.
  That 512-bit value is the seed.

  ## Options

  * `:iterations` - defaults to 2048;
  * `:length`     - a length in octets for the derived key. Defaults to 64;
  * `:digest`     - an hmac function to use as the pseudo-random function.
                    Defaults to `:sha512`;
  """
  @spec generate(String.t(), String.t(), List.t()) :: String.t()
  def generate(secret, salt, opts \\ []) do
    opts = opts
    |> Keyword.put_new(:iterations, 2048)
    |> Keyword.put_new(:length, 64)
    |> Keyword.put_new(:digest, :sha512)
    |> Enum.into(%{})

    generate(mac_fun(opts[:digest]), secret, salt, opts, 1, [])
  end

  defp generate(_fun, _secret, _salt, %{length: length}, _, _)
    when length > @max_length, do: {:error, :derived_key_too_long}

  defp generate(fun, secret, salt, opts, block_index, acc) do
    length = opts[:length]
    case IO.iodata_length(acc) > length do
      true ->
        key = acc |> Enum.reverse |> IO.iodata_to_binary
        <<bin::binary-size(length), _::binary>> = key
        bin
      false ->
        block = generate(fun, secret, salt, opts, block_index, 1, "", "")
        generate(fun, secret, salt, opts, block_index + 1, [block, acc])
    end
  end

  defp generate(_fun, _secret, _salt, %{iterations: iterations}, _block_index, iteration, _prev, acc)
    when iteration > iterations, do: acc

  defp generate(fun, secret, salt, opts, block_index, 1, _prev, _acc) do
    initial = fun.(secret, <<salt::binary, block_index::integer-size(32)>>)
    generate(fun, secret, salt, opts, block_index, 2, initial, initial)
  end

  defp generate(fun, secret, salt, opts, block_index, iteration, prev, acc) do
    next = fun.(secret, prev)
    generate(fun, secret, salt, opts, block_index, iteration + 1, next, :crypto.exor(next, acc))
  end

  defp mac_fun(digest) do
    fn key, data ->
      :crypto.hmac(digest, key, data)
    end
  end

  @doc """
  Converts a bitstring/binary value to a HEX value
  """
  @spec to_hex(Bitstring.t()) :: String.t()
  def to_hex(<<>>), do: <<>>
  def to_hex(<<char::integer-size(8), rest::binary>>) do
    hex1 = char |> div(16) |> to_hex_digit
    hex2 = char |> rem(16) |> to_hex_digit
    rest = to_hex(rest)
    <<hex1, hex2, rest::binary>>
  end

  defp to_hex_digit(n) when n < 10, do: ?0 + n
  defp to_hex_digit(n), do: ?a + n - 10
end
