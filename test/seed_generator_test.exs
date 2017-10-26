defmodule SeedGeneratorTest do
  use ExUnit.Case, async: true
  doctest SeedGenerator

  import SeedGenerator
  use Bitwise

  @max_length bsl(1, 32) - 1

  test "returns an :error tuple when the length is too large" do
    error = {:error, :derived_key_too_long}
    assert generate("secret", "salt", length: @max_length + 1) == error
  end

  test "validate seed generation 1" do
    mnemonic = "jar valid medal provide coral pet beef burger similar expand park unable"
    seed_bin = SeedGenerator.generate(mnemonic, "mnemonic")
    seed_hex = seed_bin |> SeedGenerator.to_hex()
    assert seed_hex == "3cfb7eb48977cc66186299ec6de13034512c45972bf8b7e91188c20e09231b2000d46f27302fe08d143dc0f83c3dca46ba3ede18ddb2bc138052efd2ca49d581"
  end

  test "validate seed generation 2" do
    mnemonic = "present frequent term shuffle adapt forget typical system home jewel wreck half"
    seed_bin = SeedGenerator.generate(mnemonic, "mnemonic")
    seed_hex = seed_bin |> SeedGenerator.to_hex()
    assert seed_hex == "579cc41929cc6654bbf388e9c27050d3de6b8f538b4e0b2f68dac725d883c4641f83af669d0e9c794fc99c0e578f3a19633f3f3fe2c4ab8f35f5b5629e2adbec"
  end

  test "validate seed generation 3" do
    mnemonic = "antenna arrest note aerobic sure more rocket frown envelope benefit level lesson"
    seed_bin = SeedGenerator.generate(mnemonic, "mnemonic")
    seed_hex = seed_bin |> SeedGenerator.to_hex()
    assert seed_hex == "433db92c34f1001d93cc4458d887a18e008c95bd29cab2c65a062bd76036202268db5ae334fbb78d541c49084d0055b8d05f93966c88617de31cd5c5c7fd688f"
  end

  test "validate seed generation 4" do
    mnemonic = "world voice access rebuild island pet eager couple assume scheme inflict bicycle"
    seed_bin = SeedGenerator.generate(mnemonic, "mnemonic")
    seed_hex = seed_bin |> SeedGenerator.to_hex()
    assert seed_hex == "e9d8542adbfcaee0a5113cfcf3d30a49717c481ae3c958f22cddf90a2a8290ea85cae9f67dc7b3f85f6a7101b46f9019a2aadc79d11b1e81ba66ac085b854b5e"
  end

  test "validate seed generation 5" do
    mnemonic = "trigger allow add connect gossip island dumb stairs liberty surprise surround wedding"
    seed_bin = SeedGenerator.generate(mnemonic, "mnemonic")
    seed_hex = seed_bin |> SeedGenerator.to_hex()
    assert seed_hex == "4d97a4b8a0ff4df3a1f0368308929d6d624ac08a75710d4476a97bbb8ab8286175bc1cce6133cd9b890d2b90e92e7892a8b464a368eb7b451e6c273ddf94952c"
  end
end
