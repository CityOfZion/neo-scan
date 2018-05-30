defmodule NeoscanCache.UtilsTest do
  use NeoscanCache.DataCase

  alias NeoscanCache.Utils

  test "add_new_tokens/1" do
    assert [] == Utils.add_new_tokens(Utils.add_new_tokens())
  end
end
