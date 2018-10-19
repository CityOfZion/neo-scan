defmodule NeoscanWeb.Schema do
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)
  import_types(NeoscanWeb.Schema.BlockTypes)

  query do
    import_fields(:block_queries)
  end

  @desc "paginator"
  input_object :paginator do
    field(:page_size, :integer)
    field(:page, :integer)
  end

  @desc "pagination"
  object :pagination do
    field(:total_count, non_null(:integer))
    field(:page_size, non_null(:integer))
    field(:page, non_null(:integer))
    field(:total_pages, non_null(:integer))
  end

  scalar :binary16 do
    parse(fn input ->
      Base.decode16!(input)
    end)

    serialize(fn binary ->
      Base.encode16(binary, case: :lower)
    end)
  end
end
