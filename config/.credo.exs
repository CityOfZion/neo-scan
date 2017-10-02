%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["apps/"],
        excluded: ["apps/*/deps/", "apps/*/_build", "apps/*/test", "apps/*/assets"]
      },
      checks: [
        {Credo.Check.Consistency.TabsOrSpaces},

        # For some checks, like AliasUsage, you can only customize the priority
        # Priority values are: `low, normal, high, higher`
        {Credo.Check.Design.AliasUsage, priority: :low},

        # For others you can also set parameters
        {Credo.Check.Readability.MaxLineLength, priority: :low, max_length: 80},

        # Bring up arity
        {Credo.Check.Refactor.PipeChainStart, false},

        # You can also customize the exit_status of each check.

        # To deactivate a check:
        # Put `false` as second element:
        # {Credo.Check.Design.TagFIXLATER, false},
        {Credo.Check.Refactor.FunctionArity, max_arity: 8},

        # {Credo.Check.Design.TagFIXLATER, false},
        # {Credo.Check.Design.TagTODO, false},

        # ... several checks omitted for readability ...
      ]
    }
  ]
}
