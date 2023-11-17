function first_line(s::String)
  lines = split(s, '\n')
  return string(lines[1])
end

function check(expected::Regex, real::String)
  if occursin(expected, real) == false
    @test false
    @error string("  Expected: ", expected)
    @error string("Expression: ", string(real))
  end
end

@testset "Description" begin
  doc = test_pandoc(
    """Some readme information.""";
    description = nothing,
  )
  expected_pattern = Regex("\\*test.txt\\* +For NVIM v0.8.0 +Last change: " * CURRENT_DATE)
  check(expected_pattern, first_line(doc))

  doc = test_pandoc(
    """Some readme information.""";
    vimversion = "VIM v9.0.0",
    description = nothing,
  )
  expected_pattern = Regex("\\*test.txt\\* +For VIM v9.0.0 +Last change: " * CURRENT_DATE)
  check(expected_pattern, first_line(doc))
end
