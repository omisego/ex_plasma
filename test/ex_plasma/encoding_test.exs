defmodule ExPlasma.EncodingTest do
  use ExUnit.Case, async: true
  doctest ExPlasma.Encoding

  alias ExPlasma.Encoding

  describe "keccak_hash/1" do
    test "calculates keccak hash" do
      message = "Hello world"

      result = Encoding.keccak_hash(message)

      expected_result =
        <<237, 108, 17, 176, 181, 184, 8, 150, 13, 242, 111, 91, 252, 71, 29, 4, 193, 153, 91, 15, 253, 32, 85, 146, 90,
          209, 190, 40, 214, 186, 173, 253>>

      assert result == expected_result
    end
  end

  describe "merkle_proof/2" do
    test "calculates merkle proof" do
      transactions =
        Enum.map(1..16, fn _ ->
          transaction = %ExPlasma.Transaction{
            inputs: [
              %ExPlasma.Output{
                output_data: nil,
                output_id: %{blknum: 0, oindex: 0, position: 0, txindex: 0},
                output_type: nil
              }
            ],
            metadata: <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>>,
            outputs: [
              %ExPlasma.Output{
                output_data: %{
                  amount: 10,
                  output_guard:
                    <<21, 248, 47, 41, 27, 46, 150, 159, 176, 132, 157, 153, 217, 206, 65, 226, 241, 55, 0, 110>>,
                  token: <<46, 38, 45, 41, 28, 46, 150, 159, 176, 132, 157, 153, 217, 206, 65, 226, 241, 55, 0, 110>>
                },
                output_id: nil,
                output_type: 1
              }
            ],
            sigs: [],
            tx_data: <<0>>,
            tx_type: 1
          }

          ExPlasma.Transaction.encode(transaction)
        end)

      assert Encoding.merkle_proof(transactions, 10) ==
               <<88, 117, 125, 178, 47, 156, 139, 41, 145, 135, 156, 235, 103, 89, 209, 54, 125, 132, 197, 141, 43, 93,
                 90, 83, 10, 106, 73, 111, 69, 103, 226, 241, 237, 91, 120, 10, 69, 184, 118, 141, 48, 240, 227, 211,
                 218, 252, 84, 213, 97, 229, 29, 27, 202, 99, 177, 10, 68, 111, 153, 123, 58, 173, 235, 116, 95, 95,
                 184, 2, 50, 182, 148, 249, 240, 193, 69, 241, 219, 50, 174, 40, 8, 41, 35, 175, 121, 80, 79, 221, 194,
                 47, 29, 15, 221, 56, 175, 68, 252, 116, 152, 157, 27, 104, 56, 24, 212, 11, 248, 130, 159, 3, 139, 204,
                 179, 101, 181, 147, 219, 158, 22, 62, 86, 89, 109, 34, 199, 79, 51, 235, 94, 185, 73, 105, 10, 4, 4,
                 171, 244, 206, 186, 252, 124, 255, 250, 56, 33, 145, 183, 221, 158, 125, 247, 120, 88, 30, 111, 183,
                 142, 250, 179, 95, 211, 100, 201, 213, 218, 218, 212, 86, 155, 109, 212, 127, 127, 234, 186, 250, 53,
                 113, 248, 66, 67, 68, 37, 84, 131, 53, 172, 110, 105, 13, 208, 113, 104, 216, 188, 91, 119, 151, 156,
                 26, 103, 2, 51, 79, 82, 159, 87, 131, 247, 158, 148, 47, 210, 205, 3, 246, 229, 90, 194, 207, 73, 110,
                 132, 159, 222, 156, 68, 111, 171, 70, 168, 210, 125, 177, 227, 16, 15, 39, 90, 119, 125, 56, 91, 68,
                 227, 203, 192, 69, 202, 186, 201, 218, 54, 202, 224, 64, 173, 81, 96, 130, 50, 76, 150, 18, 124, 242,
                 159, 69, 53, 235, 91, 126, 186, 207, 226, 161, 214, 211, 170, 184, 236, 4, 131, 211, 32, 121, 168, 89,
                 255, 112, 249, 33, 89, 112, 168, 190, 235, 177, 193, 100, 196, 116, 232, 36, 56, 23, 76, 142, 235, 111,
                 188, 140, 180, 89, 75, 136, 201, 68, 143, 29, 64, 176, 155, 234, 236, 172, 91, 69, 219, 110, 65, 67,
                 74, 18, 43, 105, 92, 90, 133, 134, 45, 142, 174, 64, 179, 38, 143, 111, 55, 228, 20, 51, 123, 227, 142,
                 186, 122, 181, 187, 243, 3, 208, 31, 75, 122, 224, 127, 215, 62, 220, 47, 59, 224, 94, 67, 148, 138,
                 52, 65, 138, 50, 114, 80, 156, 67, 194, 129, 26, 130, 30, 92, 152, 43, 165, 24, 116, 172, 125, 201,
                 221, 121, 168, 12, 194, 240, 95, 111, 102, 76, 157, 187, 46, 69, 68, 53, 19, 125, 160, 108, 228, 77,
                 228, 85, 50, 165, 106, 58, 112, 7, 162, 208, 198, 180, 53, 247, 38, 249, 81, 4, 191, 166, 231, 7, 4,
                 111, 193, 84, 186, 233, 24, 152, 208, 58, 26, 10, 198, 249, 180, 94, 71, 22, 70, 226, 85, 90, 199, 158,
                 63, 232, 126, 177, 120, 30, 38, 242, 5, 0, 36, 12, 55, 146, 116, 254, 145, 9, 110, 96, 209, 84, 90,
                 128, 69, 87, 31, 218, 185, 181, 48, 208, 214, 231, 232, 116, 110, 120, 191, 159, 32, 244, 232, 111, 6>>
    end
  end

  describe "merkle_root_hash/1" do
    test "calculates merkle root hash" do
      transactions =
        Enum.map(1..5, fn _ ->
          transaction = %ExPlasma.Transaction{
            inputs: [
              %ExPlasma.Output{
                output_data: nil,
                output_id: %{blknum: 0, oindex: 0, position: 0, txindex: 0},
                output_type: nil
              }
            ],
            metadata: <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>>,
            outputs: [
              %ExPlasma.Output{
                output_data: %{
                  amount: 10,
                  output_guard:
                    <<21, 248, 47, 41, 27, 46, 150, 159, 176, 132, 157, 153, 217, 206, 65, 226, 241, 55, 0, 110>>,
                  token: <<46, 38, 45, 41, 28, 46, 150, 159, 176, 132, 157, 153, 217, 206, 65, 226, 241, 55, 0, 110>>
                },
                output_id: nil,
                output_type: 1
              }
            ],
            sigs: [],
            tx_data: <<0>>,
            tx_type: 1
          }

          ExPlasma.Transaction.encode(transaction)
        end)

      assert <<62, 248, 190, 51, 105, 73, 187, 114, 207, 52, 1, 69, 68, 69, 144, 36, 104, 19, 115, 215, 67, 179, 210,
               121, 233, 229, 41, 251, 28, 86, 129, 147>> == Encoding.merkle_root_hash(transactions)
    end
  end

  describe "to_hex/1" do
    test "converts int to hex" do
      assert Encoding.to_hex(10) == "0xA"
    end

    test "converts binary to hex" do
      assert 10
             |> :binary.encode_unsigned()
             |> Encoding.to_hex() == "0x0a"
    end
  end

  describe "to_int/1" do
    test "converts hex to int" do
      assert Encoding.to_int("0xA") == 10
    end

    test "converts binary to int" do
      assert 10
             |> :binary.encode_unsigned()
             |> Encoding.to_int() == 10
    end
  end

  describe "to_binary/1" do
    test "converts hex to binary" do
      assert Encoding.to_binary("0x0a") == "\n"
    end
  end
end
