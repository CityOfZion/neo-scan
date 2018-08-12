defmodule Neoscan.Repo do
  use Ecto.Repo, otp_app: :neoscan
  use Scrivener

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    pool_size = System.get_env("POOL_SIZE")
    pool_size = if is_nil(pool_size), do: 10, else: String.to_integer(pool_size)
    {:ok, Keyword.put(opts, :pool_size, pool_size)}
  end
end
