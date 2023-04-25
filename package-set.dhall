[
  { name = "base", repo = "https://github.com/dfinity/motoko-base.git", version = "moc-0.8.6", dependencies = []: List Text },
  { name = "candy", repo = "https://github.com/icdevs/candy_library.git", version = "0.2.0", dependencies = ["base", "stablebuffer", "map"] },
  { name = "stablebuffer", repo = "https://github.com/skilesare/StableBuffer", version = "v0.2.0", dependencies = ["base"] },
  { name = "map", repo = "https://github.com/ZhenyaUsenko/motoko-hash-map", version = "v7.0.0", dependencies = ["base"] }
]
