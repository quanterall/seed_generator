# SeedGenerator

SeedGenerator is a [PBKDF2][] implementation for [Elixir][]. Conforming to [rfc2898][].

[PBKDF2]: http://en.wikipedia.org/wiki/PBKDF2
[Elixir]: http://elixir-lang.org
[rfc2898]: http://tools.ietf.org/html/rfc2898

It can be used to derive a number of keys for various purposes from a given
secret. This lets applications have a single secure secret, but avoid reusing
that key in multiple incompatible contexts.

## Usage

```elixir
defmodule User do
  import SeedGenerator

  def encrypt_password(password, salt, opts \\ []) do
    generate(password, salt, opts) |> to_hex
  end
end

key = User.encrypt_password("password", "salt")
# => "f87cbb89d972a9b96f5a9e2068308f06e1cf6421748..."
```

### Options

* `:iterations` - defaults to 2048;
* `:length`     - a length in octets for the derived key. Defaults to 64;
* `:digest`     - an hmac function to use as the pseudo-random function.
                  Defaults to `:sha512`;
