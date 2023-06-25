@testset "help-usage" begin
  panvimdoc = "./panvimdoc.sh"
  usage = cd(ROOT_DIR) do
    read(`$panvimdoc -h`, String)
  end
  @test contains(usage, "Usage:")
  @test contains(usage, "Arguments:")
end
