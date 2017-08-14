def fixture_path(file)
  File.expand_path(File.join("spec", "fixtures", file))
end

def fixture_object(file)
  File.open(File.expand_path(File.join("spec", "fixtures", file))).read
end

def fixture_json(file)
  JSON.parse File.open(file).read
end
