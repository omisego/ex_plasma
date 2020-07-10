defmodule ExPlasma.PaymentV1Builder do
  @moduledoc """
  Helper module to make crafting plasma transactions much simplier.
  """

  alias ExPlasma.Output
  alias ExPlasma.Transaction
  alias ExPlasma.Transaction.TypeMapper
  alias ExPlasma.Transaction.Type.PaymentV1

  @output_type TypeMapper.output_type_for(:output_payment_v1)

  @doc """
  Create a new Transaction

  ## Example

  # Empty payment v1 transaction
  iex> new()
  %ExPlasma.Transaction.Type.PaymentV1{inputs: [], outputs: [], metadata: <<0::256>>}

  # New payment v1 transaction with metadata
  iex> new(metadata: <<1::256>>)
  %ExPlasma.Transaction.Type.PaymentV1{inputs: [], outputs: [], metadata: <<1::256>>}
  """
  @spec new(list()) :: PaymentV1.t()
  def new(opts \\ []), do: struct(%PaymentV1{}, opts)

  @doc """
  Adds an input to the Transaction

  ## Example

  iex> new()
  ...> |> add_input(blknum: 1, txindex: 0, oindex: 0)
  ...> |> add_input(blknum: 2, txindex: 0, oindex: 0)
  %ExPlasma.Transaction.Type.PaymentV1{
    inputs: [
      %ExPlasma.Output{output_id: %{blknum: 1, txindex: 0, oindex: 0}},
      %ExPlasma.Output{output_id: %{blknum: 2, txindex: 0, oindex: 0}},
    ]
  }
  """
  @spec add_input(PaymentV1.t(), keyword()) :: PaymentV1.t()
  def add_input(txn, opts) do
    input = %Output{output_id: Enum.into(opts, %{})}
    %{txn | inputs: txn.inputs ++ [input]}
  end

  @doc """
  Adds an output to the Transaction

  ## Example

  iex> new()
  ...> |> add_output(output_data: %{output_guard: <<1::160>>, token: <<0::160>>, amount: 1})
  ...> |> add_output(output_guard: <<1::160>>, token: <<0::160>>, amount: 2)
  %ExPlasma.Transaction.Type.PaymentV1{
    outputs: [
      %ExPlasma.Output{output_type: 1, output_data: %{output_guard: <<1::160>>, token: <<0::160>>, amount: 1}},
      %ExPlasma.Output{output_type: 1, output_data: %{output_guard: <<1::160>>, token: <<0::160>>, amount: 2}},
    ]
  }
  """
  @spec add_output(PaymentV1.t(), list()) :: PaymentV1.t()
  def add_output(txn, output_data: data) do
    output = %Output{output_type: @output_type, output_data: data}
    %{txn | outputs: txn.outputs ++ [output]}
  end

  def add_output(txn, opts) when is_list(opts) do
    output = %Output{output_type: @output_type, output_data: Enum.into(opts, %{})}
    %{txn | outputs: txn.outputs ++ [output]}
  end

  @doc """
  Sign the inputs of the transaction with the given keys in the corresponding order.

  Returns a tuple {:ok, Signed payment V1 transaction} if success or {:error, atom} otherwise.

  ## Example

    iex> key = "0x79298b0292bbfa9b15705c56b6133201c62b798f102d7d096d31d7637f9b2382"
    ...> new()
    ...> |> sign(keys: [key])
    {:ok, %ExPlasma.Transaction.Signed{
      raw_tx: %ExPlasma.Transaction.Type.PaymentV1{
        inputs: [],
        outputs: [],
        metadata: <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>>,
        tx_data: 0
      },
      sigs: [
        <<129, 213, 32, 15, 183, 218, 255, 22, 82, 95, 22, 86, 103, 227, 92, 109, 9, 89, 7, 142, 235, 107, 203, 29, 20, 231,
          91, 168, 255, 119, 204, 239, 44, 125, 76, 109, 200, 196, 204, 230, 224, 241, 84, 75, 9, 3, 160, 177, 37, 181, 174,
          98, 51, 15, 136, 235, 47, 96, 15, 209, 45, 85, 153, 2, 28>>
      ]
    }}
  """
  defdelegate sign(txn, sigs), to: Transaction

  def sign!(txn, sigs) do
    {:ok, signed} = Transaction.sign(txn, sigs)
    signed
  end
end