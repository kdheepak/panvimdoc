using TestSetExtensions
using Test
using Dates
using Pandoc

ROOT_DIR = abspath(dirname(@__DIR__))
CUR_DIR = abspath(@__DIR__)
SCRIPTS_DIR = joinpath(ROOT_DIR, "scripts")
CURRENT_DATE = Dates.format(Dates.now(), dateformat"yyyy U dd")

function test_pandoc(text::String; toc = true, dedup_subheadings = false, treesitter = true, demojify = false)
  isfile(joinpath(ROOT_DIR, "doc/test.txt")) && rm(joinpath(ROOT_DIR, "doc/test.txt"))
  open(joinpath(CUR_DIR, "test.md"), "w") do file
    write(file, text)
  end
  filters = `--lua-filter=$SCRIPTS_DIR/skip-blocks.lua --lua-filter=$SCRIPTS_DIR/include-files.lua`
  if demojify
    filters = `$filters --lua-filter=$SCRIPTS_DIR/remove-emojis.lua`
  end
  cd(ROOT_DIR) do
    run(
      `$(Pandoc.pandoc()) --metadata=project:"test" --metadata=vimversion:"NVIM v0.8.0" --metadata=toc:$toc --metadata=description:"Test Description" --metadata=dedupsubheadings:$dedup_subheadings --metadata=treesitter:$treesitter $filters -t $SCRIPTS_DIR/panvimdoc.lua $CUR_DIR/test.md -o test/test.txt`,
    )
  end
  doc = read(joinpath(ROOT_DIR, "test/test.txt"), String)
  rm(joinpath(ROOT_DIR, "test/test.txt"))
  rm(joinpath(CUR_DIR, "test.md"))
  return doc
end

@testset ExtendedTestSet "All the tests" begin
  @includetests ARGS
end
