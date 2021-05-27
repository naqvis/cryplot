require "ecr"
require "compiler/crystal/formatter"

# Download the git submodule gnuplot-palettes
system("git submodule update --init")

root = Path[__DIR__].parent
palettes_dir = root.join("deps/gnuplot-palettes")

files = Dir.glob(palettes_dir.join("*.pal")).map { |p| Path[p] }.sort!

palettes = Hash(String, String).new

files.each do |f|
  palettes[f.basename.gsub(f.extension, "").capitalize] = File.read(f)
end

output = String.build do |str|
  ECR.embed "#{__DIR__}/palettes.ecr", str
end
output = Crystal.format(output)
File.write("#{__DIR__}/../src/plot/palettes.cr", output)
