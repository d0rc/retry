defmodule RetryTest do
  use ExUnit.Case

  test "it works" do
    result = Retry.run fn -> :ets.insert :hello, {2,1} end, %{sleep: 0, tries: 1000}
  	assert %{attempts: 1000, state: :failed} = result
  end
end
