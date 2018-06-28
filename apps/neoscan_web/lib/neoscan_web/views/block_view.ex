defmodule NeoscanWeb.BlockView do
  use NeoscanWeb, :view
  import Number.Delimit
  import NeoscanWeb.CommonView

  def check_if_invocation({"invocation", _hash}) do
    true
  end

  def check_if_invocation({"verification", _hash}) do
    false
  end

  def check_if_invocation(nil) do
    true
  end

  def check_if_verification({"verification", _hash}) do
    true
  end

  def check_if_verification({"invocation", _hash}) do
    false
  end

  def check_if_verification(nil) do
    true
  end
end
