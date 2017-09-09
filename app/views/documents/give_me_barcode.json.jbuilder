json.data do
  json.array!(@product) do |x|
    json.extract! x, :id,
      :barcode,
      :price_out,
  end
end
