defmodule RetryTest do
  use ExUnit.Case

  test "it works" do
    result = Retry.run %{sleep: 0, tries: 1000}, fn -> 
    	:ets.insert :hello, {2,1} 
    end
  	assert {:error, %{attempts: 1000, state: :failed}} = result
  end

  test "it still works" do
  	result = Retry.run fn -> "it works" end
  	assert {:ok, "it works"} = result
  end
end
